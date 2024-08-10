function varargout = applyFunctionsToSelectedEdges(G,functionArray,edges,remaining)
% Applies the specified set of functions to the specified edges
% Inputs:
% FUNCTIONARRAY the array of functions
% EDGES the edges to apply them to (must be same length)
% REMAINING what to do with the remaining edges. May take values
%           'leavealone' (default) do not set any values on the remaining edges
%           'zero' set the values on remaining edges to zero
% Outputs
% VARARGOUT (optional) a column vector of the resulting y-values
if ~exist('remaining','var')
    remaining='leavealone';
end

assert(strcmp(remaining,'zero')||strcmp(remaining,'leavealone'),'remaining can only take values zero and leavealone')

assert(length(functionArray)==length(edges),'The number of elements in the function array must match the number of edges.')
for k=1:length(edges)
   G.applyFunctionToEdge(functionArray{k},edges(k)); 
end
if strcmp(remaining,'zero')
    leftovers=setdiff(1:G.numedges,edges);
    for k=1:length(leftovers)
        G.applyFunctionToEdge(0,leftovers(k))
    end
end

G.interpAtNodes;
if nargout>0
    varargout{1}=G.graph2column;
end