function varargout=straightEdge(G,edge,plotCoords)
% Create a discretized line segment for plotting a given edge of the
% quantum graph G 

endNodes=G.EndNodes(edge);
node1=endNodes(1);
node2=endNodes(2);
assert(node1~=node2,'Straight edges must start and end at the different nodes')

x1start=plotCoords.x1Node(node1);
x1end=plotCoords.x1Node(node2);
x1=G.distributePlotCoords(x1start,x1end,edge);

x2start=plotCoords.x2Node(node1);
x2end=plotCoords.x2Node(node2);
x2=G.distributePlotCoords(x2start,x2end,edge);

if ~G.has3DLayout
    varargout={x1,x2};
else
    x3start=plotCoords.x3Node(node1);
    x3end=plotCoords.x3Node(node2);
    x3=G.distributePlotCoords(x3start,x3end,edge);
    varargout={x1,x2,x3};
end

