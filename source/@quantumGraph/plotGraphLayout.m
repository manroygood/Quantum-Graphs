function plotGraphLayout(G)
% Plots a graph G over its skeleton. 
% Graph must have Nodes.x1 and Nodes.x2 defined
if G.has3DLayout
    plotGraphLayout3D(G)
else 
    plotGraphLayout2D(G)
end

