function fcns=getNLSFunctionsGraph(Phi,fSymbolic)
% The functions used by the nonlinear continuation routines for continuing
% the focusing cubic NLS on a graph
% M is the Laplacian matrix
% f is the basic function. It must be a symbolic function of z. 
% It is assumed that f(0) = f'(0) = 0
% All the others are its derivatives
% We assume that
%                 Lambda Psi+ Laplacian Psi + f(Psi) =0

syms z 
if ~exist('fSymbolic','var')
    fSymbolic = 2*z^3;
end
fprime= matlabFunction(diff(fSymbolic));
fpp = matlabFunction(diff(fSymbolic,2));
f = matlabFunction(fSymbolic);
F = matlabFunction(2*int(f,[0 z])); % The factor of two is correct but subtle.
% % It comes from the fact that F'(|u|^2)u = f'(u)


assert(f(0)==0,'Must assume f(0)=0')
assert(fprime(0)==0,'Must assume fprime(0)=0')

A = Phi.laplacianMatrixWithVC;
B = Phi.interpolationMatrixWithZeros;

nA=length(A);
fcns.fSymbolic = fSymbolic;
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