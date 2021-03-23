function len = L(G,j)
if nargin==1
    len = G.qg.Edges.L;
else
    len = G.qg.Edges.L(j);
end
end
