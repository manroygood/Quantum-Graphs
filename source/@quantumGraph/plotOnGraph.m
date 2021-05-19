function plotOnGraph(G,myColor)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

if G.has3DLayout
    G.plotOnGraph3D;
else
    G.plotOnGraph2D(myColor);
end