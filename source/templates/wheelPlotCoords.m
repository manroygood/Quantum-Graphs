function plotCoords = wheelPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the tribell
% These are independent of the coordinates used to define the tribell
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

radius = Phi.distributePlotCoords(0,L,1);

nextPoint = exp(1i*2*pi/n);
zEdge = Phi.distributePlotCoords(L,L*nextPoint,n+1);

for j=1:n
    % Radius
    z =radius*exp(1i*phi(j));
    plotCoords.x1Edge{j}=real(z);
    plotCoords.x2Edge{j}=imag(z);
    % Edge segment
    z =zEdge*exp(1i*phi(j));
    plotCoords.x1Edge{j+n}=real(z);
    plotCoords.x2Edge{j+n}=imag(z);
end