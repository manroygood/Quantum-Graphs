function plotGraphLayout(G,muteFlag)
% Plots a graph G over its skeleton. 
% Graph must have Nodes.x1 and Nodes.x2 defined
if G.has3DLayout
    plotGraphLayout3D(G,muteFlag)
else 
    plotGraphLayout2D(G,muteFlag)
end

