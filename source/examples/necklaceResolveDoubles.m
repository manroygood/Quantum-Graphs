function vv=necklaceResolveDoubles(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on dumbell
% graph in order to display that these eigenfunctions are identically zero
% on some edges

V1=V(:,k);
V2=V(:,k+1);
Phi.column2graph(V1);y1=Phi.Edges.y{end};
Phi.column2graph(V2);y2=Phi.Edges.y{end};
a=y1(1)+y1(end);
b=y2(1)+y2(end);


v1= a*V2 - b*V1;
v1 = v1/Phi.norm(v1);
v2= V2 - Phi.dot(v1,V2)*v1;
v2 = v2/Phi.norm(v2);
vv{1}=v1;
vv{2}=v2;