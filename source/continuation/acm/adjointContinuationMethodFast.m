function [t,u,period] = adjointContinuationMethodFast(Phi,u0,T,mu)
% This Adjoint Continuation Method follows from the purposed scheme by 
% Williams, Wilkenings, Shlizerman and Kutz in Continuations of Periodic 
% Solutions in the Waveguide array Mode-locked laser. See Appendix A.
%
% This program finds a periodic solution to u_t = f(t,u) defined on Phi.
% Given parameters:
%  Phi: quantum graph
%  u0: initial condition / solution to stationary problem
%  T: initial guess for period
    
    A = Phi.laplacianMatrix;
    B = Phi.weightMatrix;
    f =@(t,z) -1i*( (A+mu*B)*z + B*(2*z.^2.*conj(z)));     % LHS of u_t = f(u,t)
    G = @(x) functionalG(Phi,f,x,mu);                      % Compute G and grad G from u, u_conj, u_t and u_0
    
    options = optimoptions('fminunc','SpecifyObjectiveGradient',true); % By default HessianApproximation is bfgs so maybe this doesn't need to be set
    uinfo = fminunc(G,[real(u0);imag(u0);T],options);                  % Finds where G = 0 near uend giving us the period
    
    [~,~,nTot] = Phi.nx;
    u0 = uinfo(1:nTot) + 1i* uinfo(nTot+1:2*nTot);
    period = uinfo(end);
    save 'uinfo.mat' uinfo;

    [t,u] = Phi.timeEvolveARK(f,u0,10^(-01),period);  % Evolve u(x,t) until t=period and store solution as final output
    
end



function [G,gradG] = functionalG(Phi,f,x,mu)
% Defines the functional G(x,T) with u(x,T) and u_0(x) and 
% defines gradG using with u_0(x), u(x,T-s) and u_T(x,T).
    n = (length(x)-1)/2;
    u0 = x(1:n) + 1i*x(n+1:2*n);                       % Reconstruct u0 and T from x
    T = x(end);

    [t,u] = Phi.timeEvolve15s(f,u0,(-0.1):10^(-01):(T+0.1)); % Evolve u(x,t) until t=T and store solution...
    uend = u(:,end);
    uT = f(t,uend);                                    % ...and time derivative

    uend = u(:,end);
    G = Phi.dot(uend-u0,conj(uend-u0))/2;
    
    GT = real(Phi.dot(uT,conj(uend-u0)) + Phi.dot(uend+u0,conj(uT)));
    Q0 = uend - u0;
    Q = Qfunc(Phi,Q0,u,t,T,mu);                    % Evolve adjoint equation until s=T
    Gu0 = Q - Q0;

    gradG = [real(Gu0); imag(Gu0); GT];
    
end


function Qend = Qfunc(Phi,Q0,u,t,T,mu)
% Solves the  Qs = DF* Q  equation for Q
    Qs = @(s,Q) DFstar(s,Q,Phi,u,t,T,mu);
    [~,Q] = Phi.timeEvolveARK(Qs,Q0,10^(-01),T);
    Qend = Q(:,end);
end


function fstar = DFstar(s,Q,Phi,u,t,T,mu)
% Defines DF* as a function of u(x,T-s)
    A = Phi.laplacianMatrix;
    B = Phi.weightMatrix;
    uTminusS = transpose(interp1(t,transpose(u),T-s));
    fstar = 1i*(A+mu*B)*Q + 4i*(uTminusS.*conj(uTminusS)).*Q + 2i*(uTminusS.^2).*conj(Q);
end