function X = x(G,j)
if nargin==1
    X = G.qg.Edges.x;
else
    X = G.qg.Edges.x(j);
end
end