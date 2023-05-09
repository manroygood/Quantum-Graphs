function addInteriorGridUniform(G)

nEdges=G.numedges;
x = G.x;
for k=1:nEdges
    x{k}=x{k}(2:end-1);
end
y = cell(nEdges,1);

G.addEdgeField('xInterior',x);
G.addEdgeField('yInterior',y);