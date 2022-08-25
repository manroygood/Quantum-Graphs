function plotCoords = dumbbellPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the dumbbell
% These are independent of the coordinates used to define the dumbbell
% initially

plotCoords=Phi.initPlotCoords;

L=Phi.L(2);
plotCoords.x1Node=[-1; 1]*L/2;
plotCoords.x2Node=[0; 0];

% Left hoop
edge=1;
[hoopLeftX1,hoopLeftX2] = Phi.circularEdge(edge,'left',plotCoords);

% Handle
edge=2;
[handleX1,handleX2] = Phi.straightEdge(edge,plotCoords);

% Right hoop
edge=3;
[hoopRightX1,hoopRightX2] = Phi.circularEdge(edge,'right',plotCoords);

plotCoords.x1Edge={hoopLeftX1; handleX1; hoopRightX1};
plotCoords.x2Edge={hoopLeftX2; handleX2; hoopRightX2};