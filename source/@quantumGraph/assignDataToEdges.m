function assignDataToEdges(G,dataArray)
nEdges= G.numedges;
assert(any(size(dataArray)==nEdges),'input dimension must match number of edges')
s=inputname(2);
assert(~any(strcmp(s,G.qg.Edges.Properties.VariableNames)),...
       'New variable name must be different from existing variable names.')

if ~(size(dataArray,1)==nEdges)
    dataArray=dataArray.';
end
G.qg.Edges.(s)=dataArray;