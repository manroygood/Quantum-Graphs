function plotCoords = cloverPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the clover
% These are independent of the coordinates used to define the clover
% initially

plotCoords=Phi.initPlotCoords;
L=Phi.L;
nLeaves =length(L);

% Define the coordinates of the nodes

plotCoords.x1Node=0;
plotCoords.x2Node=0;

% Assign coordinates to the edges
if nLeaves==2
    openingAngle = pi/2;
else
    openingAngle = pi/nLeaves;
end

for j=1:nLeaves
    theta0 = (j-1)*2*pi/nLeaves;
    [X1,X2]=Phi.teardropEdge(j,theta0,openingAngle,plotCoords);
    plotCoords.x1Edge{j}=X1;
    plotCoords.x2Edge{j}=X2;
end