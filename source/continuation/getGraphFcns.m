function fcns=getGraphFcns(M)
% The functions used by the nonlinear continuation routines for continuing
% the focusing cubic NLS on a graph
% M is the Laplacian matrix
% f is the basic function. All the others are its derivatives
nM=length(M);
fcns.f =@(z,Lambda)( M*z + 2*z.^3  + Lambda*z);
fcns.fLinMatrix = @(z,Lambda) (M + spdiags( 6*z.^2 + Lambda,0,nM,nM));
fcns.fLinMatrixMinus= @(z,Lambda) (M + spdiags( 2*z.^2 + Lambda,0,nM,nM));
fcns.fullLinearization=@(z,Lambda)[sparse(nM,nM) fcns.fLinMatrix(z,Lambda);...
                                   -fcns.fLinMatrixMinus(z,Lambda) sparse(nM,nM)];
fcns.fMu = @(z,Lambda)(z); % This is df/dmu where mu (i.e. Lambda) is the bifurcation parameter, here Lambda
fcns.fxMu = @(z,Lambda)(speye(nM));
fcns.fxxu =@(z,Lambda,u)spdiags(12*z.*u,0,nM,nM); % this is fxx*u, which takes a little more thinking about

% This is Fzz considered as a tensor that takes three arguments,
% essentially a cubic form
fcns.fTriple=@(z,u,v,w) (12*sum(z.*u.*v(1:end-1).*w(1:end-1)) + ...
                         dot(u,v(end)*w(1:end-1)+w(end)*v(1:end-1)));