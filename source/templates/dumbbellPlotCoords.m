function plotCoords = dumbbellPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the dumbbell
% These are independent of the coordinates used to define the dumbbell
% initially

LVec=Phi.L;
rLeft=LVec(1)/2/pi;
rRight=LVec(3)/2/pi;
L=LVec(2);

plotCoords.x1Node=[-1; 1]*L/2;
plotCoords.x2Node=[0; 0];

nx=Phi.nx;

% Left hoop
edge=1;
theta=Phi.distributePlotCoords(0,2*pi,edge);
hoopLeftX1 = -L/2 -rLeft +rLeft*cos(theta);
hoopLeftX2 = rLeft*sin(theta);

% Handle
edge=2;
handleX1 = Phi.distributePlotCoords(-L/2,L/2,edge);
handleX2 = zeros(size(handleX1));

% Right hoop
edge=3;
theta = Phi.distributePlotCoords(0,2*pi,edge);
hoopRightX1 = L/2 + rRight - rRight*cos(theta);
hoopRightX2 = rRight*sin(theta);

plotCoords.x1Edge={hoopLeftX1; handleX1; hoopRightX1};
plotCoords.x2Edge={hoopLeftX2; handleX2; hoopRightX2};