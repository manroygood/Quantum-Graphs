function varargout = fullEdge(G,k)
Edges=G.Edges; 
Nodes=G.Nodes;
n1=Edges.EndNodes(k,1);
n2=Edges.EndNodes(k,2);
x1=[Nodes.x1(n1); Edges.x1{k}; Nodes.x1(n2)];
x2=[Nodes.x2(n1); Edges.x2{k}; Nodes.x2(n2)];

y=[Nodes.y(n1); Edges.y{k}; Nodes.y(n2)];

if G.has3DLayout
    x3=[Nodes.x3(n1); Edges.x3{k}; Nodes.x3(n2)];
    varargout={x1,x2,x3,y};
else
    varargout={x1,x2,y};
end