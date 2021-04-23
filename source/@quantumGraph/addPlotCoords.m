function addPlotCoords(G,plotCoordFcn)

plotCoords=plotCoordFcn(G);

G.qg.Edges.x1=plotCoords.x1Edge;
G.qg.Edges.x2=plotCoords.x2Edge;
G.qg.Nodes.x1=plotCoords.x1Node;
G.qg.Nodes.x2=plotCoords.x2Node;

if isfield(plotCoords,'x3Edge')
    G.qg.Edges.x3=plotCoords.x3Edge;
    G.qg.Nodes.x3=plotCoords.x3Node;
end
