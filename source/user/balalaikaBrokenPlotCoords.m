function plotCoords = balalaikaBrokenPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the star
% These are independent of the coordinates used to define the star
% initially

plotCoords=Phi.initPlotCoords;

L1 = Phi.L(1);
L2 = Phi.L(4);
L3 = Phi.L(2);
L4 = Phi.L(7);

x1 = 0;
x2 = L1;
x3 = (L1^2-L2^2+L3^2)/2/L1;
x4 = x3;

y1 = 0;
y2 = 0;
y3 = sqrt((L1+L2+L3)*(-L1+L2+L3)*(L1-L2+L3)*(L1+L2-L3))/2/L1;
y4 = y3+ L4;

epsilon = 0.2*min(Phi.L);
plotCoords.x1Node=[x1;x2;x1+epsilon;x3;x2;x3+epsilon;x4;x3-epsilon];
plotCoords.x2Node=[y1;y2;y1+epsilon;y3;y2+epsilon;y3+epsilon;y4;y3+epsilon];

for k=1:8
    [x1,x2]= Phi.circularArcEdge(k,pi/8,'plus',plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end