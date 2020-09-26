function plotCoords = dumbbellPlotCoords(dumbbell)
% Creates coordinates on which to lay out functions defined on the dumbbell
% These are independent of the coordinates used to define the dumbbell
% initially

LVec=dumbbell.L;
r=LVec(1)/2/pi;
L=LVec(2);

plotCoords.x1Node=[-1; 1]*L/2;
plotCoords.x2Node=[0; 0];

n1=dumbbell.Edges.nx(1);
theta=2*pi*((1:n1)-1/2)'/n1;

n2=dumbbell.Edges.nx(2);
x = ((1:n2)-1/2)'/n2;

hoopLeftX1 = -L/2 -r +r*cos(theta);
handleX1 = -L/2 + L*x;
hoopRightX1 = L/2 + r - r*cos(theta);

hoopLeftX2 = r*sin(theta);
handleX2 = zeros(size(x));
hoopRightX2 = r*sin(theta);

plotCoords.x1Edge={hoopLeftX1; handleX1; hoopRightX1};
plotCoords.x2Edge={hoopLeftX2; handleX2; hoopRightX2};