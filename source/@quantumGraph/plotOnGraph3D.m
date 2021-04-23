function plotOnGraph3D(G)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

clf;
nEdges=numedges(G);

for k=1:nEdges
    [x1,x2,x3,y]=G.fullEdge(k);
    colorplot3(x1,x2,x3,y)
    hold on
end
hold off

axis equal tight off
view([-37.5 30])
colorbar

end

function colorplot3(x1,x2,x3,y)
surface([x1 x1]',[x2 x2]',[x3 x3]',[y y]',...
    'facecolor','none','edgecolor','interp','linewidth',4);
end
% This function is based on
% https://www.mathworks.com/matlabcentral/answers/5042-how-do-i-vary-color-along-a-2d-line