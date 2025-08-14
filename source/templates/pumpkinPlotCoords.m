function plotCoords = pumpkinPlotCoords(Phi)

plotCoords=Phi.initPlotCoords;

L=Phi.L;
numEdges =length(L);

plotCoords.x1Node=[-1;1];
plotCoords.x2Node=[ 0;0];

scale=linspace(1,-1,numEdges);
for k=1:numEdges
    [x1,x2]=Phi.semicircularEdge(k,'plus',plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2*scale(k);
end

