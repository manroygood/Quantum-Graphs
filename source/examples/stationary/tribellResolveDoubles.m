function v=tribellResolveDoubles(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on tribell
% graph in order to display that these eigenfunctions are identically zero
% on some edges
nx=Phi.nx;
N1=nx(1); N2=nx(4);
V1=V(:,k);
V2=tribellShift(V1,N1,N2);
[~,p]=max(abs(V1));
v1= V1*V2(p)-V2*V1(p); 
v{1}=v1/Phi.norm(v1);
v{2}=tribellShift(V1,N1,N2);