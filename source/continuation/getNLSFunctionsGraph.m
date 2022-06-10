function fcns=getNLSFunctionsGraph(Phi,F)
% The functions used by the nonlinear continuation routines for continuing
% the focusing cubic NLS on a graph
% M is the Laplacian matrix
% F is the basic function. It must be a symbolic function of z. 
% All the others are its derivatives
% We assume Lambda Psi = Laplacian Psi + F'(Psi^2) Psi so that 

% Note: initially F is defined as a function of z but at the last step, we
% substitute in z^2

syms z
if ~exist('f','var')
    F = z^2;
end
Fprime = diff(F);
f = subs(Fprime,z,z^2)*z;
fprime= matlabFunction(diff(f));
fpp = matlabFunction(diff(f,2));
f = matlabFunction(f);
F = matlabFunction(subs(F,z,z^2));

A = Phi.laplacianMatrix;
B = Phi.weightMatrix;

nA=length(A);
fcns.f =@(z,Lambda)( A*z + B*(f(z) + Lambda*z));
fcns.fLinMatrix = @(z,Lambda) (A + B*spdiags(fprime(z)+Lambda,0,nA,nA));
fcns.fMu = @(z,Lambda)(B*z); % This is df/dmu where mu (i.e. Lambda) is the bifurcation parameter, here Lambda
fcns.fxMu = @(z,Lambda)(B);
fcns.fxxu =@(z,Lambda,u)B*spdiags(fpp(z).*u,0,nA,nA); % this is fxx*u, which takes a little more thinking about
fcns.F = F; % used in computing the energy

% This is Fzz considered as a tensor that takes three arguments,
% essentially a cubic form
% This is used in (7.130) of Govaerts 2000 SIAM book
% Note the components (1:end-1) of phi1 and phi2 contain the function 
% and the end component contains the frequency parameter Lambda
fcns.fTriple=@(z,psi,phi1,phi2) dot(psi, (phi2(end)*B*phi1(1:end-1) + phi1(end)*B*phi2(1:end-1)) ...
                                        + B* (fpp(z).*phi1(1:end-1).*phi2(1:end-1)));