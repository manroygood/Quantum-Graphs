function vv=starResolveDoubles(V,k,Phi)
% ASsumes that the 2nd and third edges are the same

nx=Phi.nx;
N1=nx(1);N2=nx(2);
% Recombines the eigenfunctions of multiplicity-two eigenvalues on tribell
% graph in order to display that these eigenfunctions are identically zero
% on some edges
V1=V(:,k);
V2=V(:,k+1);
% v1 is an eigenfunction that is zero on the "upright" part
[m,p]=max(abs(V1(1:N1)));m1=m*sign(V1(p));
[m,p]=max(abs(V2(1:N1)));m2=m*sign(V1(p));
v1=m1*V2-m2*V1; 
vv{1}=v1/Phi.norm(v1);

% v2 is an eigenfunction that is zero on one of the "arms"
[m,p]=max(abs(V1(N1+1:N1+N2)));m1=m*sign(V1(N1+p));
[m,p]=max(abs(V2(N1+1:N1+N2)));m2=m*sign(V2(N1+p));
v2=m1*V2-m2*V1;
vv{2}=v2/Phi.norm(v2);