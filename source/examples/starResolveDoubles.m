function vv=starResolveDoubles(V,k,Phi)
% Asumes that the 2nd and third edges are the same
% Then vv{1} has an even symmetry, while vv{2} has an odd symmetry.

[~,nxC,~]=Phi.nx;
edge1=(nxC(2)+1):nxC(3);
edge2=(nxC(3)+1):nxC(4);
V1=V(:,k);
V2=V1;
V2(edge1)=V1(edge2);
V2(edge2)=V1(edge1);

v1= (V1+V2)/2; vv{1}=v1/Phi.norm(v1);
v2= (V1-V2)/2; vv{2}=v2/Phi.norm(v1);