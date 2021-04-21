function z = dx(G,j)
if nargin ==1
    z = G.qg.Edges.dx;
else
    z = G.qg.Edges.dx(j);
end
end
