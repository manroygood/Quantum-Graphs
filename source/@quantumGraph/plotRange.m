function [x1Range,x2Range,yMin,yMax,yRange]=plotRange(G)
% helper function for plotting the data contained in a graph G
nEdges=numedges(G);
Edges=G.Edges; 
Nodes=G.Nodes;

x1Min=min(Nodes.x1); x1Max=max(Nodes.x1);
x2Min=min(Nodes.x1); x2Max=max(Nodes.x1);

yMax=-inf;
yMin=inf;
for k=1:nEdges
    x1Min = min(x1Min,min(Edges.x1{k}));
    x1Max = max(x1Max,max(Edges.x1{k}));
    x2Min = min(x2Min,min(Edges.x2{k}));
    x2Max = max(x2Max,max(Edges.x2{k}));
    yMax=max(yMax,max(Edges.y{k}));
    yMin=min(yMin,min(Edges.y{k}));
    yMin=min(yMin,0); % Fix for everywhere positive graphs
end

x1Range=x1Max-x1Min;
x2Range=x2Max-x2Min;
yRange=yMax-yMin;