function plotCoords = poissonExamplePlotCoords(Phi)

LVec=Phi.L;

plotCoords.x1Node=[0;4;4];
plotCoords.x2Node=[0;0;-1];

plotCoords.x1Edge = cell(4,1);
plotCoords.x2Edge = cell(4,1);

% Edge 1
theta=Phi.distributePlotCoords(0,2*pi,1);
plotCoords.x1Edge{1} = cos(theta)-1;
plotCoords.x2Edge{1} = sin(theta);

% Edge 2
plotCoords.x1Edge{2} = Phi.distributePlotCoords(0,4,2);
plotCoords.x2Edge{2} = zeros(size(plotCoords.x1Edge{2}));

% Edge 3
theta=Phi.distributePlotCoords(0,2*pi,3);
plotCoords.x1Edge{3} = sin(theta)+4;
plotCoords.x2Edge{3} = -cos(theta)+1;

% Edge 4
plotCoords.x2Edge{4} = Phi.distributePlotCoords(0,-1,4);
plotCoords.x1Edge{4} = 4+zeros(size(plotCoords.x2Edge{4}));

