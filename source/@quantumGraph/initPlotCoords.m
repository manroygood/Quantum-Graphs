function plotCoords=initPlotCoords(G)

numnodes=G.numnodes;
plotCoords.x1Node=zeros(numnodes,1);
plotCoords.x2Node=zeros(numnodes,1);

numedges=G.numedges;
plotCoords.x1Edge = cell(numedges,1);
plotCoords.x2Edge = cell(numedges,1);

if G.has3DLayout
    plotCoords.x3Node=zeros(numnodes,1);
    plotCoords.x3Edge = cell(numedges,1);
end