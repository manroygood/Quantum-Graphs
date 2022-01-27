function assignDataToNodes(G,dataArray)
nNodes= G.numnodes;
assert(any(size(dataArray)==nNodes),'input dimension must match number of nodes')
s=inputname(2);
assert(~any(strcmp(s,G.qg.Nodes.Properties.VariableNames)),...
       'New variable name must be different from existing variable names.')

if ~(size(dataArray,1)==nNodes)
    dataArray=dataArray.';
end
G.qg.Nodes.(s)=dataArray;