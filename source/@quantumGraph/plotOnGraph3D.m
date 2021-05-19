function plotOnGraph3D(G)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

clf;
nEdges=numedges(G);
G.interpAtNodes;
for k=1:nEdges
    [x1,x2,x3,y]=G.fullEdge(k);
    colorplot3(x1,x2,x3,y);
    hold on
end
hold off

axis equal tight off
view([-37.5 30])
colorbar