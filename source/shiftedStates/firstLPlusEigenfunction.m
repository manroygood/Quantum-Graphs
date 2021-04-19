function eigenfunction=firstLPlusEigenfunction(Phi,x0)
% Side effect, assigns the eigenfunction to the y-component of the graph
LPlus= Lplus(Phi);

[V,d]=eig(full(LPlus));
d=diag(d);
[~,ord]=sort(d,'descend'); 
V=real(V(:,ord));
nx = Phi.nx(1); % Lazily written. Assumes that all branches of the star graph have the same number of points
nEdges=Phi.numedges;
if x0>0
    nn=nEdges*nx-2;
else
    nn=nEdges*nx-1;
end

eigenfunction=V(:,nn);
eigenfunction(1:nx)=0; % We know this eigenfunction is zero on the first edge, so we're just eliminating the numerical error
Phi.column2graph(eigenfunction);
eigenfunction = Phi.graph2column/Phi.norm;

eigenfunction(1:nx)=0; % We know this eigenfunction is zero on the first edge, so we're just eliminating the numerical error