function applyFunctionsToAllEdges(G,functionArray)

assert(length(functionArray),G.numedges,'The number of elements in the function array must match the number of edges.')
for k=1:G.numedges
   G.applyFunctionToEdge(functionArray{k},k); 
end