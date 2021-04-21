function Phi=qgCheb(tag,LVec,nxVec,robinCoeff)
% A shortcut function for creating a quantum graph
% There must exist in the path three functions
% <tag>Template.m  -- the source and target nodes
% <tag>PlotCoords.m --- A function that sets up the plotting cooordinates

plotCoordFunction=str2func([tag 'PlotCoords']);

Phi = quantumGraph([1 1 2], [1 2 2], LVec, 'nxVec', nxVec,'RobinCoeff', robinCoeff,...
    'discretization', 'Chebyshev', 'plotCoordinateFcn',plotCoordFunction);
