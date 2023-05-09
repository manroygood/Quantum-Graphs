function applyFunctionToInteriorEdge(G,func,j)
% Applies a function to the interior of edge G of quantum graph G
% If func is a numerical scalar, then it is interpreted as a constant function
% If func is a numerical vector, and the same size as the discretized edge,
%    then the vector is copied to the edge, transposed if necessary

if isa(func,'function_handle')
    y = func(G.xInterior{j});
elseif isnumeric(func)
    if isscalar(func)
        y=func*ones(size(G.xInterior{j}));
    elseif all(size(func)==size(G.xInterior{j}))
        y=func;
    elseif all(size(func')==size(G.xInterior{j}))
        y=func';
    end
end
G.qg.Edges.yInterior{j}=y;