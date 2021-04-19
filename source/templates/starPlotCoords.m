function plotCoords = starPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the tribell
% These are independent of the coordinates used to define the tribell
% initially

LVec=Phi.L;
n =length(LVec);

phi = 2*pi/n*(0:n-1)';
z = LVec .* exp(1i*phi);
plotCoords.x1Node=[0; real(z)];
plotCoords.x2Node=[0; imag(z)];

plotCoords.x1Edge = cell(n,1);
plotCoords.x2Edge = cell(n,1);

for k=1:n
    x = Phi.distributePlotCoords(0,LVec(k),k);
    plotCoords.x1Edge{k}=x*cos(phi(k));
    plotCoords.x2Edge{k}=x*sin(phi(k));
end