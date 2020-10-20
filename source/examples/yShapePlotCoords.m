function plotCoords = yShapePlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the dumbbell
% These are independent of the coordinates used to define the dumbbell
% initially

LVec=Phi.L;
L1=LVec(1);
L2=LVec(2);
nx=Phi.nx;

plotCoords.x1Node=[-L1;0;L2/sqrt(2);L2/sqrt(2)];
plotCoords.x2Node=[0; 0; L2/sqrt(2);-L2/sqrt(2)];

nx1=nx(1);
x1_stem=((-nx1:-1)-1/2)'*L1/nx1;
x2_stem=zeros(nx1,1);

nx2=nx(2);
x1_arm=((1:nx2)-1/2)'*L2/sqrt(2)/nx2;

plotCoords.x1Edge={x1_stem;x1_arm;x1_arm;};
plotCoords.x2Edge={x2_stem;x1_arm;-x1_arm};