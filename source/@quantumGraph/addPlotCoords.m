function addPlotCoords(G,plotCoordFcn)

plotCoords=plotCoordFcn(G);

G.qg.Edges.x1=plotCoords.x1Edge;
G.qg.Edges.x2=plotCoords.x2Edge;
G.qg.Nodes.x1=plotCoords.x1Node;
G.qg.Nodes.x2=plotCoords.x2Node;