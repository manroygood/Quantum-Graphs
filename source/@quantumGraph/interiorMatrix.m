function im = interiorMatrix(G,j)
% Returns the cell array of interior matrices or the interior matrix at node j
assert(G.isUniform,'qg.interiorMatrixNotUniform','interior Matrix only defined for uniform discretization')
if nargin==1
    im = G.qg.Nodes.interiorMat;
else
    im = G.qg.Nodes.interiorMat{j};
end
end