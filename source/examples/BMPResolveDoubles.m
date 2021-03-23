function vv=BMPResolveDoubles(V,k,Phi)
nx=Phi.nx;
n1=nx(1);n2=nx(2);
% Recombines the eigenfunctions of multiplicity-two eigenvalues on dumbell
% graph in order to display that these eigenfunctions are identically zero
% on some edges
V1=V(:,k);
V1edge2=V1(n1+1:n1:n2);[~,p]=max(abs(V1edge2));
V2=V(:,k+1);
spot=n1+p;
v1= V1*V2(spot)-V2*V1(spot); v1=v1/norm(v1);

v2 = V2 - dot(v1,V2)*v1; v2=v2/norm(v2);
vv{1}=v1;
vv{2}=v2;