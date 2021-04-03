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
n1=nx(1);
theta1=2*pi*((1:n1)-1/2)'/n1;

n2=nx(2);
x = ((1:n2)-1/2)'/n2;

n3 = nx(3);
theta3 = 2*pi*((1:n3)-1/2)'/n3;

hoopLeftX1 = -L/2 -rLeft +rLeft*cos(theta1);
handleX1 = -L/2 + L*x;
hoopRightX1 = L/2 + rRight - rRight*cos(theta3);

hoopLeftX2 = rLeft*sin(theta1);
handleX2 = zeros(size(x));
hoopRightX2 = rRight*sin(theta3);

plotCoords.x1Edge={hoopLeftX1; handleX1; hoopRightX1};
plotCoords.x2Edge={hoopLeftX2; handleX2; hoopRightX2};