function plotCoords = helmPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the helm
% graph

LVec=Phi.L;
n =length(LVec)/3;
r1=LVec(1);   % Length of first inner spoke
r2=LVec(n+2); % Length of first outer spoke

phi = 2*pi/n*(0:n-1)';
zInner = r1 * exp(1i*phi);
zOuter = (r1+r2) * exp(1i*phi);
plotCoords.x1Node=[0; real(zInner); real(zOuter)];
plotCoords.x2Node=[0; imag(zInner); imag(zOuter)];

plotCoords.x1Edge = cell(3*n,1);
plotCoords.x2Edge = cell(3*n,1);

for k=1:Phi.numedges
    [x1,x2]=Phi.straightEdge(k,plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end