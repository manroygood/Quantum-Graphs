function varargout = applyFunctionsToAllEdges(G,functionArray)

assert(length(functionArray),G.numedges,'The number of elements in the function array must match the number of edges.')
for k=1:G.numedges
   G.applyFunctionToEdge(functionArray{k},k); 
end
G.interpAtNodes;
if nargout>0
    varargout{1}=G.graph2column;
end