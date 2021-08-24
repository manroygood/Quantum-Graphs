function outputNewDirection(fcns,xBif,muBif,xOld,outputDir,k,dotProduct,ds)
% When a branch bifurcation is detected, outputs the direction of the
% perturbation direction
% This is based on Section 7.8.4 of 
% Govaerts book Numerical Methods for Bifurcations of Dynamical Equilibria,
% SIAM 2000

Fkx=fcns.fLinMatrix(xBif,muBif);
Fkmu = fcns.fMu(xBif,muBif);
Fbig=full([Fkx Fkmu]); % This is the matrix G_z

% This defines the vectors psi, phi1, phi2 in between eqns (7.129) and
% (7.130)
[U,~,V] = svd(Fbig);
psi=U(:,end);
phi1=V(:,end-1);
phi2=V(:,end);
a11=fcns.fTriple(xBif,psi,phi1,phi1);
a12=fcns.fTriple(xBif,psi,phi1,phi2);
a22=fcns.fTriple(xBif,psi,phi2,phi2);
rr=roots([a11 2*a12 a22]);  % Essentially (7.131), should probably test for a11=0 or a22=0 first
direction1 = rr(1)*phi1 + phi2;
direction2 = rr(2)*phi1 + phi2;

xDir1=direction1(1:end-1);muDir1=direction1(end);
xDir2=direction2(1:end-1);muDir2=direction2(end);
n1=sqrt(dotProduct.big(xDir1,xDir1,muDir1,muDir1));
n2=sqrt(dotProduct.big(xDir2,xDir2,muDir2,muDir2));
xDir1=ds*xDir1/n1; muDir1=ds*muDir1/n1;
xDir2=ds*xDir2/n2; muDir2=ds*muDir2/n2;

branchDirection= xOld-xBif;
dot1=abs(dotProduct.dot(xDir1,branchDirection));
dot2=abs(dotProduct.dot(xDir2,branchDirection));

if dot1 > dot2 % In this case the first direction is parallel to the current branch
    xPerturbation = xDir2;
    LambdaPerturbation = muDir2;
else % so the second direction is parallel to the current branch
    xPerturbation = xDir1; 
    LambdaPerturbation = muDir1; 
end
label=getLabel(k);
xfile=['PhiPerturbation.' label '.mat'];xfile =fullfile(outputDir,xfile);
mufile=['LambdaPerturbation.' label '.mat'];mufile =fullfile(outputDir,mufile);
save(xfile,'xPerturbation')
save(mufile,'LambdaPerturbation');