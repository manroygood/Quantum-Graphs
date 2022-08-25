function plotCoords = bubbleTowerPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the bubble tower
% These are independent of the coordinates used to define the bubble tower initially
plotCoords=Phi.initPlotCoords;

nNodes = Phi.numnodes;
nEdges=Phi.numedges;
n=(nEdges-1)/2;


% Define the coordinates of the nodes
L= Phi.L(1);
r= [Phi.L(3:2:2*n-1)/pi ; Phi.L(end)/2/pi];

plotCoords.x1Node=zeros(nNodes,1);
plotCoords.x2Node=zeros(nNodes,1);

plotCoords.x1Node(2:3) = L*[-1;1];
plotCoords.x2Node(4:nNodes)=2*cumsum(r(1:end-1));

% Edges 1 and 2 are straight line segments
[plotCoords.x1Edge{1},plotCoords.x2Edge{1}]=Phi.straightEdge(1,plotCoords);
[plotCoords.x1Edge{2},plotCoords.x2Edge{2}]=Phi.straightEdge(2,plotCoords);

for k=3:2:nEdges-2
    [x1,x2]=Phi.semicircularEdge(k,'plus',plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;

    [x1,x2]=Phi.semicircularEdge(k+1,'minus',plotCoords);
    plotCoords.x1Edge{k+1}=x1;
    plotCoords.x2Edge{k+1}=x2;
end

[x1,x2]=Phi.circularEdge(nEdges,'up',plotCoords);
plotCoords.x1Edge{nEdges}=x1;
plotCoords.x2Edge{nEdges}=x2;

