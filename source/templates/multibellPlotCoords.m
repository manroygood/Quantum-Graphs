function plotCoords = multibellPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the tribell
% These are independent of the coordinates used to define the tribell
% initially

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
    % The straight parts
    n1=Phi.Edges.nx(j);
    handle = Phi.distributePlotCoords(0,L(j),j);
    %z =handle*exp(1i*phi(j));
    plotCoords.x1Edge{j}=handle*cos(phi(j));
    plotCoords.x2Edge{j}=handle*sin(phi(j));
    
    % The round parts
    n2=Phi.Edges.nx(nBells+j);
    theta = Phi.distributePlotCoords(0,2*pi,j+nBells);
    hoop = L(j) +r(j)*(1-exp(1i*theta));
    %z =hoop*exp(1i*phi(j));
    plotCoords.x1Edge{j+nBells}=real(hoop*exp(1i*phi(j)));
    plotCoords.x2Edge{j+nBells}=imag(hoop*exp(1i*phi(j)));
end