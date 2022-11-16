function animatePDESolution(G,U,t,nSkip)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined


if ~exist('nSkip','var'); nSkip = 1; end

if G.has3DLayout
    G.animatePDESolution3D(U,t,nSkip);
else
    G.animatePDESolution2D(U,t,nSkip);
end  