function plotCoords = plotCoordFcnFromNodes(G,nodes)

nEdges=G.numedges;


plotCoords.x1Node = nodes(:,1);
plotCoords.x2Node = nodes(:,2);
plotCoords.x3Node = nodes(:,3);

plotCoords.x1Edge = cell(nEdges,1);
plotCoords.x2Edge = cell(nEdges,1);
plotCoords.x3Edge = cell(nEdges,1);

for k=1:nEdges
    nodeStart=nodes(G.source(k),:);
    nodeEnd = nodes(G.target(k),:);
    plotCoords.x1Edge{k} = G.distributePlotCoords(nodeStart(1),nodeEnd(1),k);
    plotCoords.x2Edge{k} = G.distributePlotCoords(nodeStart(2),nodeEnd(2),k);
    plotCoords.x3Edge{k} = G.distributePlotCoords(nodeStart(3),nodeEnd(3),k);
end