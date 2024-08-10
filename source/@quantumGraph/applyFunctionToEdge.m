function applyFunctionToEdge(G,func,j)
% Applies a function to edge G of quantum graph G
% If func is a numerical scalar, then it is interpreted as a constant function
% If func is a numerical vector, and the same size as the discretized edge,
%    then the vector is copied to the edge, transposed if necessary

if isa(func,'function_handle')
    y = func(G.x{j});
elseif isnumeric(func)
    if isscalar(func)
        y=func*ones(size(G.x{j}));
    elseif all(size(func)==size(G.x{j}))
        y=func;
    elseif all(size(func')==size(G.x{j}))
        y=func';
    end
else
    error('applyfunctionToEdge:bad_function')
end
G.qg.Edges.y{j}=y;