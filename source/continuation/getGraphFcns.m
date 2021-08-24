function fcns=getGraphFcns(Phi,f)
% The functions used by the nonlinear continuation routines for continuing
% the focusing cubic NLS on a graph
% M is the Laplacian matrix
% f is the basic function. All the others are its derivatives

if nargin ==1
    syms z
    f = 2*z^3;
end
fprime= matlabFunction(diff(f));
fpp = matlabFunction(diff(f,2));
f = matlabFunction(f);

A = Phi.laplacianMatrix;
B = Phi.weightMatrix;

nA=length(A);
fcns.f =@(z,Lambda)( A*z + B*(f(z) + Lambda*z));
fcns.fLinMatrix = @(z,Lambda) (A + B*spdiags(fprime(z)+Lambda,0,nA,nA));
fcns.fMu = @(z,Lambda)(B*z); % This is df/dmu where mu (i.e. Lambda) is the bifurcation parameter, here Lambda
fcns.fxMu = @(z,Lambda)(B);
fcns.fxxu =@(z,Lambda,u)B*spdiags(fpp(z).*u,0,nA,nA); % this is fxx*u, which takes a little more thinking about

% This is Fzz considered as a tensor that takes three arguments,
% essentially a cubic form
% This is used in (7.130) of Govaerts 2000 SIAM book
% Note the components (1:end-1) of phi1 and phi2 contain the function 
% and the end component contains the frequency parameter Lambda
fcns.fTriple=@(z,psi,phi1,phi2) dot(psi, (phi2(end)*B*phi1(1:end-1) + phi1(end)*B*phi2(1:end-1)) ...
                                        + B* (fpp(z).*phi1(1:end-1).*phi2(1:end-1)));