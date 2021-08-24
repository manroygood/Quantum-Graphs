function [nxVec,nxC,nxTot]=nx(G,varargin)

% Returns the number of points in the mesh on the quantum graph G
if nargin==1
    nxVec=(G.Edges.nx);
    nxPlus=nxVec+2;
    nxC=[0;cumsum(nxPlus)];
    nxTot=nxC(end);
else % if the second argument is a positive integer, return nx on that branch
    j = varargin{1};
    nxVec=(G.Edges.nx);
    nxVec=nxVec(j);
end