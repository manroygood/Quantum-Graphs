function applyGraphicalFunction(G,f)

if ismember('relinked', G.qg.Edges.Properties.VariableNames)
    relinked=G.qg.Edges.relinked;
else
    relinked=zeros(G.numedges,1);
end


if ~G.has3DLayout
    G.qg.Nodes.y=f(G.Nodes.x1,G.Nodes.x2);
    for k=1:G.numedges
        if ~relinked(k)
            G.qg.Edges.y{k}=f(G.Edges.x1{k},G.Edges.x2{k});
        else
            node1=G.qg.Edges.EndNodes(k,1);
            node2=G.qg.Edges.EndNodes(k,2);
            y1=G.qg.Nodes.y(node1);
            y2=G.qg.Nodes.y(node2);
            G.qg.Edges.y{k} = y1+ (y2-y1)*G.x{k}/G.L(k);
        end
    end
else
    G.qg.Nodes.y=f(G.Nodes.x1,G.Nodes.x2,G.Nodes.x3);
    for k=1:G.numedges
        G.qg.Edges.y{k}=f(G.Edges.x1{k},G.Edges.x2{k},G.Edges.x3{k});
    end
end
G.interpAtNodes;