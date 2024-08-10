function z = integrationWeight(G,j)
if nargin ==1
    z = G.qg.Edges.integrationWeight;
else
    z = G.qg.Edges.integrationWeight{j};
end
end
