function gm = ghostMatrix(G,j)
% Returns the cell array of ghost matrices or the ghost matrix at node j
assert(G.uniform,'qg.ghostMatrixNotUniform','ghost Matrix only defined for uniform discretization')
if nargin==1
    gm = G.qg.Nodes.ghostMatrix;
else
    gm = G.qg.Nodes.ghostMatrix{j};
end
end