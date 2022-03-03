function [t,u,period] = adjointContinuationMethod(Phi,u0,T)
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
    f =@(t,z) -1i*( A*z + B*(2*z.^2.*conj(z)));  % LHS of u_t = f(u,t)
    
    [t,u] = Phi.timeEvolveDH(f,u0,T);       % Evolve u(x,t) until t=T and store solution...
    uend = u(:,end);
    ut = f(t,uend);                         % ...and time derivative
    
    
    [G,gradG] = functionalG(Phi,f,uend,ut,u0,T);   % Compute G and grad G from u, u_conj, u_t and u_0
    
    
    options = optimoptions('HessianApproximation', 'bfgs','SpecifyObjectiveGradient',gradG);  % DID I SET OPTIONS CORRECTLY ??
    period = fminunc(G,uend,options);      % Finds where G = 0 near uend giving us u(x,period)
    
    % SHOULD ALL THIS BE IN A LOOP DETERMINING IF G IS CONVERGING  TO ZERO 
    % AND UPDATING T OTHERWISE ??

    % HOW DO I GET THE FULL SOLUTION OF U FROM 0 TO t=PERIOD?
    [t,u] = Phi.timeEvolveDH(f,u0,period);  % Evolve u(x,t) until t=period and store solution as final output

end



function [G,gradG] = functionalG(Phi,f,uend,uT,u0,T)
% Defines the functional G(x,T) with u(x,T) and u_0(x) and 
% defines gradG using with u_0(x), u(x,T-s) and u_T(x,T).
    
    G = Phi.dot(uend-u0,conj(uend-u0))/2;
    
    GT = Phi.dot(uT,conj(uend-u0)) + Phi.dot(uend+u0,conj(uT));
    
    Q0 = uend - u0;
    Q = Qfunc(Phi,Q0,f,u0,T);       % Evolve adjoint equation until s=T
    Gu0 = Q - Q0;

    gradG = [GT; Gu0];
    
end


function Qend = Qfunc(Phi,Q0,f,u0,T)
% Solves the Qs = DF* Q equation for Q
    Qs = @(s,Q) DFstar(s,Q,Phi,f,u0,T)*Q;
    [~,Q] = Phi.timeEvolveDH(Qs,Q0,T);
    Qend = Q(:,end);

end


function fstar = DFstar(s,Q,Phi,f,u0,T)
% Defines DF* as a function of u(x,T-s)

    A = Phi.laplacianMatrix;
    [~,uTminusS] = Phi.timeEvolveDH(f,u0,T-s);
    u = uTminusS(:,end);
    fstar = @(s,Q) -1i*A*Q - 2i*(u*u')*Q + 1i*(u*transpose(u))*conj(Q);

end