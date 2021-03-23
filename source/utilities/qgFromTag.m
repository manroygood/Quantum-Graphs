function Phi=qgFromTag(tag,LVec,nxVec,robinCoeff)
% A shortcut function for creating a quantum graph
% There must exist in the path three functions
% <tag>Template.m  -- the source and target nodes
% <tag>PlotCoords.m --- A function that sets up the plotting cooordinates
templateFunction=str2func([tag 'Template']);
[source,target]=templateFunction([]);
if isempty(robinCoeff)
    robinCoeff=zeros(max(target),1);
end
plotCoordFunction=str2func([tag 'PlotCoords']);
Phi = quantumGraph(source, target,LVec,'nxVec',nxVec,'robinCoeff',robinCoeff,'plotCoordinateFcn',plotCoordFunction);
