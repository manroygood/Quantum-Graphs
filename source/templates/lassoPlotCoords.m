function plotCoords = lassoPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the lasso
% These are independent of the coordinates used to define the lasso
% initially

plotCoords=Phi.initPlotCoords;

L=Phi.L;
if isinf(L(2))
    y2=-sinh(Phi.stretch(2));
else
    y2 = -L(2);
end

% % Define the coordinates of the nodes
% 
% plotCoords.x1Node=[0; y2];
% plotCoords.x2Node=[0; 0];
% 
% % Assign coordinates to the edges
% 
% % The round part
% [hoopX1,hoopX2]=Phi.circularEdge(1,0,plotCoords);
% plotCoords.x1Edge{1}=hoopX1;
% plotCoords.x2Edge{1}=hoopX2;
% 
% % The straight part
% [lineX1,lineX2]=Phi.straightEdge(2,plotCoords);
% plotCoords.x1Edge{2}=lineX1;
% plotCoords.x2Edge{2}=lineX2;

% Define the coordinates of the nodes

plotCoords.x1Node=[0; 0];
plotCoords.x2Node=[0; y2];

% Assign coordinates to the edges

% The round part
[hoopX1,hoopX2]=Phi.circularEdge(1,pi,plotCoords);
plotCoords.x1Edge{1}=hoopX2;
plotCoords.x2Edge{1}=hoopX1;

% The straight part
[lineX1,lineX2]=Phi.straightEdge(2,plotCoords);
plotCoords.x1Edge{2}=lineX1;
plotCoords.x2Edge{2}=lineX2;