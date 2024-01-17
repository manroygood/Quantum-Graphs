function varargout = applyFunctionsToAllEdges(G,functionArray)
% The functions are evaluated only at the interior points of each edge, and
% then extended to the vertex or ghost points using the extendWithVC method
assert(length(functionArray),G.numedges,'The number of elements in the function array must match the number of edges.')

if ~G.hasEdgeField('xInterior')
    G.addInteriorGrid;
end
for k=1:G.numedges
   G.applyFunctionToInteriorEdge(functionArray{k},k); 
end
rhs = G.graphInterior2column + (G.nonhomogeneousVCMatrix) * G.nodeData;
PVC = G.extendWithVC(G.interpolationMatrix);

f = PVC\rhs;
G.column2graph(f);
G.interpAtNodes;
if nargout>0
    varargout{1}=f;
end
