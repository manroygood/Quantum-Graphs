function addInteriorGridChebyshev(G)

nEdges=G.numedges;
LVec=G.L;
nxVec = G.nx;

x = cell(nEdges,1);
for k=1:nEdges
    x{k} = LVec(k)*chebptsFirstKind(nxVec(k));
end
y = cell(nEdges,1);

G.addEdgeField('xInterior',x);
G.addEdgeField('yInterior',y);
