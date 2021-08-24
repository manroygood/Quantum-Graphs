function [ghostPt,interiorPt]=getEndPoints(G,rowDirection,rowBranch)
% Helper function for finding the indices of the ghost point and the first
% interior point for a quantum graph object with UNIFORM discretization

assert(G.isUniform,'quantumGraph:notUniformNoGhost',...
    'The graph does not have uniform discretization, so ghost points not defined');
[~,nxC,~]=nx(G);
if rowDirection== 1            % If this is an incoming edge
    ghostPt=nxC(rowBranch+1);
    interiorPt = ghostPt-1;
elseif rowDirection == -1      % If this is an outgoing edge
    ghostPt=nxC(rowBranch)+1;
    interiorPt= ghostPt+1;
end
end