function plotCoords = BMPPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the
% multi-handle dumbbell used by Berkolaiko, Marzuola, & Pelinovsky


plotCoords=Phi.initPlotCoords;

L=Phi.L(2);
plotCoords.x1Node=[-1; 1]*L/2;
plotCoords.x2Node=[0; 0];

% Left hoop
[hoop1X1,hoop1X2] = Phi.circularEdge(1,'left',plotCoords);

% Edge 2, straight handle
[handle2X1,handle2X2] = Phi.straightEdge(2,plotCoords);

% Edge 3, upper semicircular handle
[handle3X1,handle3X2] = Phi.semicircularEdge(3,'plus',plotCoords);

% Edge 4, upper semicircular handle
[handle4X1,handle4X2] = Phi.semicircularEdge(4,'minus',plotCoords);

% Right hoop
[hoop5X1,hoop5X2] = Phi.circularEdge(5,'right',plotCoords);

plotCoords.x1Edge={hoop1X1; handle2X1; handle3X1; handle4X1; hoop5X1};
plotCoords.x2Edge={hoop1X2; handle2X2; handle3X2; handle4X2; hoop5X2};