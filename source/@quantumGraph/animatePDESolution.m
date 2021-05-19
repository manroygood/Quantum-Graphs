function animatePDESolution(Phi,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

if Phi.has3DLayout
    Phi.animatePDESolution3D(U,t);
else
    Phi.animatePDESolution2D(U,t);
end