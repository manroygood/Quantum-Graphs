function applyGraphicalFunction(G,f)

if ~G.has3DLayout
    G.qg.Nodes.y=f(G.Nodes.x1,G.Nodes.x2);
    for k=1:G.numedges
        G.qg.Edges.y{k}=f(G.Edges.x1{k},G.Edges.x2{k});
    end
else
    G.qg.Nodes.y=f(G.Nodes.x1,G.Nodes.x2,G.Nodes.x3);
    for k=1:G.numedges
        G.qg.Edges.y{k}=f(G.Edges.x1{k},G.Edges.x2{k},G.Edges.x3{k});
    end
end