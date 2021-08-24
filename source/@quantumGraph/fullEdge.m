function varargout = fullEdge(G,k)
y=G.Edges.y{k};
x1=G.Edges.x1{k};
x2=G.Edges.x2{k};

if G.isUniform
    n1=G.EndNodes(k,1);
    n2=G.EndNodes(k,2);
    
    y(1) = G.Nodes.y(n1);
    y(end) =  G.Nodes.y(n2);    
end

if G.has3DLayout
    x3 = G.Edges.x3{k};
    varargout={y,x1,x2,x3};
else
    varargout={y,x1,x2};
end
    