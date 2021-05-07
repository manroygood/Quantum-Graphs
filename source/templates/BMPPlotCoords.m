function plotCoords = BMPPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the
% multi-handle dumbbell used by Berkolaiko, Marzuola, & Pelinovsky
% These are independent of the coordinates used to define the dumbbell
% initially

% Assumes that the length of each handle/hoop and the discretization number
% on that edge are the same

LVec=Phi.L;
r1=LVec(1)/2/pi;
L=LVec(2);

plotCoords.x1Node=[-1; 1]*L/2;
plotCoords.x2Node=[0; 0];

nx=Phi.nx;

thetaHoop=Phi.distributePlotCoords(0,2*pi,1);
hoop1X1 = -L/2 -r1 +r1*cos(thetaHoop);
hoop1X2 = r1*sin(thetaHoop);

handle2X1 = Phi.distributePlotCoords(-L/2,L/2,2);
handle2X2 = zeros(nx(2),1);

theta2 = Phi.distributePlotCoords(pi,0,2);
handle3X1= L/2*cos(theta2);
handle3X2= L/2*sin(theta2);

handle4X1 = handle3X1;
handle4X2 = -handle3X2;

hoop5X1 = L/2 + r1 - r1*cos(thetaHoop);
hoop5X2 = r1*sin(thetaHoop);

plotCoords.x1Edge={hoop1X1; handle2X1; handle3X1; handle4X1; hoop5X1};
plotCoords.x2Edge={hoop1X2; handle2X2; handle3X2; handle4X2; hoop5X2};