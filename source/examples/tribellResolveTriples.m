function vOut=tribellResolveTriples(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-three eigenvalues on dumbell
% graph in order to display that these eigenfunctions are identically zero
% on some edges
nx=Phi.nx;
N1=nx(1); N2=nx(4);
v1=V(:,k);
v2=tribellShift(v1,N1,N2);
v3=tribellShift(v2,N1,N2);
vv=[v1 v2 v3];
M=vv(end-ceil((N2+2)/2)*(1:2:5),:);
w1=M\[1;0;0];
vv1=vv*w1; vOut{1}=vv1/Phi.norm(vv1);
w1=M\[0;1;0];
vv2=vv*w1; vOut{2}=vv2/Phi.norm(vv2);
w1=M\[0;0;1];
vv3=vv*w1; vOut{3}=vv3/Phi.norm(vv3);