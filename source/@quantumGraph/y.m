function yy = y(G,j)
% Returns the y-value cell array or the y value on the jth edge

if nargin==1
    yy = G.qg.Edges.y;
else
    yy = G.qg.Edges.y{j};
end
end