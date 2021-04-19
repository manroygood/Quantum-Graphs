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

nextPoint = exp(1i*2*pi/n);
zEdge = Phi.distributePlotCoords(r1,r1*nextPoint,1);

spoke = Phi.distributePlotCoords(r1,r1+r2,n+1);

for k=1:n
    % segment of the circumference
    z1 =zEdge*exp(1i*phi(k));
    plotCoords.x1Edge{2*k-1}=real(z1);
    plotCoords.x2Edge{2*k-1}=imag(z1);
    
    %sticky-outy bit
    z1 =spoke*exp(1i*phi(k));
    plotCoords.x1Edge{2*k}=real(z1);
    plotCoords.x2Edge{2*k}=imag(z1);
end