function plotCoords = multibellPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the multibell
% These are independent of the coordinates used to define the multibell
% initially

plotCoords=Phi.initPlotCoords;

L=Phi.L;
nBells =length(L)/2;
L=L(1:nBells);  

% Define the coordinates of the nodes
phi = 2*pi/nBells*(0:nBells-1)';
z = L .* exp(1i*phi);
plotCoords.x1Node=[0; real(z)];
plotCoords.x2Node=[0; imag(z)];

% Assign coordinates to the edges
for j=1:nBells
    % The straight parts
    [lineX1,lineX2]=Phi.straightEdge(j,plotCoords);
    plotCoords.x1Edge{j}=lineX1;
    plotCoords.x2Edge{j}=lineX2;
    
    % The round parts
    [hoopX1,hoopX2]=Phi.circularEdge(nBells+j,pi+phi(j),plotCoords);
    plotCoords.x1Edge{j+nBells}=hoopX1;
    plotCoords.x2Edge{j+nBells}=hoopX2;
end