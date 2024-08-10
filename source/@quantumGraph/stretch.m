function y = stretch(G,j)
if nargin==1
    y = G.qg.Edges.stretch;
else
    y = G.qg.Edges.stretch(j);
end
end
