function plotOnGraph3D(G)
% Plots a graph G 
% Graph must have Nodes.x1 and Nodes.x2 defined

clf;
nEdges=numedges(G);
G.interpAtNodes;
y=graph2column(G); 
ymin = min(min(y),min(G.Nodes.y));
ymax = max(max(y),max(G.Nodes.y));
yrange = [ymin ymax];
for k=1:nEdges
    [y,x1,x2,x3]=G.fullEdge(k);
    colorplot3(x1,x2,x3,y,yrange);
    hold on
end
hold off

axis equal tight off
view([-37.5 30])
colorbar