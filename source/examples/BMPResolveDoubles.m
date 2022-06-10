function vv=BMPResolveDoubles(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on BMP
% graph in order to display that these eigenfunctions are identically zero
% on some edges
% Zero out the solution on edge 2
V1=V(:,k);
Phi.column2graph(V1);
[~,p]=max(abs(Phi.y{2}));
V1m=Phi.y{2}(p);

V2=V(:,k+1);
Phi.column2graph(V2);
V2m=Phi.y{2}(p);
v1= V1*V2m-V2*V1m; v1=v1/Phi.norm(v1);

% Use Gram-Schmidt to get the second eigenfunction
v2 = V2 - Phi.dot(v1,V2)*v1; v2=v2/Phi.norm(v2);
vv{1}=v1;
vv{2}=v2;