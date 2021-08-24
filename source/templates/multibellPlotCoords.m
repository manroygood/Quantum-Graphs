function plotCoords = multibellPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the
% multibell.
% These are independent of the coordinates used to define the multibell
% initially.
% No effort has been made to prevent the overlap of edges

LVec=Phi.L;
nBells =length(LVec)/2;
r=LVec(nBells+1:2*nBells)/2/pi;
L=LVec(1:nBells);

phi = 2*pi/nBells*(0:nBells-1)';
z = L .* exp(1i*phi);
plotCoords.x1Node=[0; real(z)];
plotCoords.x2Node=[0; imag(z)];

plotCoords.x1Edge = cell(2*nBells,1);
plotCoords.x2Edge = cell(2*nBells,1);

for j=1:nBells
    phaseShift=exp(1i*phi(j));
    
    % The straight parts
    handle = Phi.distributePlotCoords(0,L(j),j) * phaseShift;
    plotCoords.x1Edge{j}=real(handle);
    plotCoords.x2Edge{j}=imag(handle);
    
    % The round parts
    theta = Phi.distributePlotCoords(0,2*pi,j+nBells);
    hoop = (L(j) +r(j)*(1-exp(1i*theta))) * phaseShift;
    plotCoords.x1Edge{j+nBells}=real(hoop);
    plotCoords.x2Edge{j+nBells}=imag(hoop);
end