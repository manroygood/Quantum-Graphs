function plotCoords = sunletPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the tribell
% These are independent of the coordinates used to define the tribell
% initially

LVec=Phi.L;
n =length(LVec)/2;
r1=LVec(1);
r2=LVec(2);

phi = 2*pi/n*(0:n-1)';
z1 = r1 * exp(1i*phi);
z2 = (r1+r2) * exp(1i*phi);
plotCoords.x1Node=[real(z1); real(z2)];
plotCoords.x2Node=[imag(z1); imag(z2)];

plotCoords.x1Edge = cell(2*n,1);
plotCoords.x2Edge = cell(2*n,1);

for k=1:Phi.numedges
    [x1,x2]=Phi.straightEdge(k,plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end