function fcns=getGraphFcns(A,B)
% The functions used by the nonlinear continuation routines
% f is the basic function. All the others are its derivatives

n = length(A);

fcns.f = @(u,mu)(A*u + B*(2*u.^3  + mu*u));                             % u_x + 2u^3 + mu*u = stationary eval prob
fcns.fLinMatrix = @(u,mu) (A + B*spdiags( 6*(u).^2 + mu,0,n,n));        % = df/du = L+
fcns.fLinMatrixMinus = @(u,mu) (A + B*spdiags( 2*u.^2 + mu,0,n,n));     % = L-
fcns.fullLinearization=@(z,Lambda)[sparse(n,n) fcns.fLinMatrix(z,Lambda);...
                                   -fcns.fLinMatrixMinus(z,Lambda) sparse(n,n)];  % = [0 L+; -L- 0] = [0 L- ; -L+ 0] = JL op


fcns.fMu = @(u,mu)(B*u);                       % f_mu where mu is the bifurcation parameter
fcns.fxMu = @(u,mu)B*(speye(n));               % f_xmu = partial wrt x then mu
fcns.fxxz = @(u,mu,z)B*spdiags(12*u.*z,0,n,n); % f_xx*z, which takes a little more thinking about


% This is Fzz considered as a tensor that takes three arguments,
% essentially a cubic form
fcns.fTriple=@(z,u,v,w) (12*sum(u.*z.*v(1:end-1).*w(1:end-1)) + ...
                         dot(z,v(end)*w(1:end-1)+w(end)*v(1:end-1))); % Hessian
