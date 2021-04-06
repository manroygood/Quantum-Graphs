% Returns the weight vector or the jth element of the weight vector
function w = weight(G,j)
if nargin==1
    w = G.qg.Edges.Weight;
else
    w = G.qg.Edges.Weight(j);
end
end