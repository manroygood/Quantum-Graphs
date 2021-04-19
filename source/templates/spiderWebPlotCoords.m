function plotCoords = spiderWebPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the tribell
% These are independent of the coordinates used to define the tribell
% initially

LVec=Phi.L;
n =length(LVec)/4;
r1=LVec(1);   % Length of first inner spoke
r2=LVec(n+2); % Length of first outer spoke

phi = 2*pi/n*(0:n-1)';
zInner = r1 * exp(1i*phi);
zOuter = (r1+r2) * exp(1i*phi);
plotCoords.x1Node=[0; real(zInner); real(zOuter)];
plotCoords.x2Node=[0; imag(zInner); imag(zOuter)];

plotCoords.x1Edge = cell(3*n,1);
plotCoords.x2Edge = cell(3*n,1);

innerRadius = Phi.distributePlotCoords(0,r1,1);
outerRadius = Phi.distributePlotCoords(r1,r1+r2,n+2);

nextPoint = exp(1i*2*pi/n);
zEdgeInner = Phi.distributePlotCoords(r1,r1*nextPoint,n+1);
zEdgeOuter = Phi.distributePlotCoords(r1+r2,(r1+r2)*nextPoint,Phi.numedges);

for k=1:n
    % inner spoke
    zInner =innerRadius*exp(1i*phi(k));
    plotCoords.x1Edge{k}=real(zInner);
    plotCoords.x2Edge{k}=imag(zInner);
    % inner circumference
    zInner =zEdgeInner*exp(1i*phi(k));
    plotCoords.x1Edge{n+2*k-1}=real(zInner);
    plotCoords.x2Edge{n+2*k-1}=imag(zInner);
    % outer spoke
    zOuter =outerRadius*exp(1i*phi(k));
    plotCoords.x1Edge{n+2*k}=real(zOuter);
    plotCoords.x2Edge{n+2*k}=imag(zOuter);    
    % outer circumference
    zOuter =zEdgeOuter*exp(1i*phi(k));
    plotCoords.x1Edge{3*n+k}=real(zOuter);
    plotCoords.x2Edge{3*n+k}=imag(zOuter);
end