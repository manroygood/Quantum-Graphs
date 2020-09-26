function [nxVec,nxC,nxTot]=nx(G)
% Returns the number of points in the mesh on the quantum graph G
nxVec=(G.Edges.nx);
nxC=[0;cumsum(nxVec)];
nxTot=nxC(end);