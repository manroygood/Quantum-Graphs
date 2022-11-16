function pcolor3(G,u,uRange)


if exist('u','var')
    G.column2graph(u);
end

if ~exist('uRange','var')
    uRange=[min(u) max(u)];
end

hold off
for k=1:G.numedges
    [y,x1,x2,x3]=G.fullEdge(k);
    colorplot3(x1,x2,x3,y,uRange);
    hold on
end
axis equal off
view([70 40])
colorbar