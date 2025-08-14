function vv=cloverResolveDoubles(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on 2-clover
% graph in order to display that these eigenfunctions are identically zero
% on some edges

V1=V(:,k);
V2=flip(V1);
[~,p]=max(abs(V1));
v1= V1*V2(p)-V2*V1(p); v1=v1/Phi.norm(v1);
v2= flip(v1);
vv{1}=v1;
vv{2}=v2;