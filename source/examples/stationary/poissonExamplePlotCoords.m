function plotCoords = poissonExamplePlotCoords(Phi)

L=Phi.L;

plotCoords.x1Node=[0;L(2);L(2)];
if isinf(L(4))
    y4=-sinh(Phi.stretch(4));
else
    y4 = -L(4);
end
plotCoords.x2Node=[0;0;y4];
plotCoords.x1Edge = cell(4,1);
plotCoords.x2Edge = cell(4,1);

% Edge 1
theta=Phi.distributePlotCoords(0,2*pi,1);
plotCoords.x1Edge{1} = L(1)*(cos(theta)-1)/2/pi;
plotCoords.x2Edge{1} = L(1)*sin(theta)/2/pi;

% Edge 2
plotCoords.x1Edge{2} = Phi.distributePlotCoords(0,L(2),2);
plotCoords.x2Edge{2} = zeros(size(plotCoords.x1Edge{2}));

% Edge 3
theta=Phi.distributePlotCoords(0,2*pi,3);
plotCoords.x1Edge{3} = L(3)*sin(theta)/2/pi+L(2);
plotCoords.x2Edge{3} = L(3)*(-cos(theta)+1)/2/pi;

% Edge 4
plotCoords.x2Edge{4} = Phi.distributePlotCoords(0,y4,4);
plotCoords.x1Edge{4} = L(2)+zeros(size(plotCoords.x2Edge{4}));