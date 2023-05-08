function varargout = applyFunctionsToAllEdges(G,functionArray)

assert(length(functionArray),G.numedges,'The number of elements in the function array must match the number of edges.')

if ~G.hasEdgeField('xInterior')
    G.addInteriorGrid;
end
for k=1:G.numedges
   G.applyFunctionToInteriorEdge(functionArray{k},k); 
end
rhs = G.graphInterior2column;
PVC = G.extendWithVC(G.interpolationMatrix);

f = PVC\rhs;
G.column2graph(f);
G.interpAtNodes;
if nargout>0
    varargout{1}=f;
end
