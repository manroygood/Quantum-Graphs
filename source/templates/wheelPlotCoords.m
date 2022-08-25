function plotCoords = wheelPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the wheel
% These are independent of the coordinates used to define the wheel
% initially

LVec=Phi.L;
n =length(LVec)/2;
L=LVec(1);

phi = 2*pi/n*(0:n-1)';
z = L * exp(1i*phi);
plotCoords.x1Node=[0; real(z)];
plotCoords.x2Node=[0; imag(z)];

plotCoords.x1Edge = cell(2*n,1);
plotCoords.x2Edge = cell(2*n,1);

for k=1:Phi.numedges
    [x1,x2]=Phi.straightEdge(k,plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end