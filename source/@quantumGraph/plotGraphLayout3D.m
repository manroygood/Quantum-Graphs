function plotGraphLayout3D(G,muteFlag)
creamcolor=[255 253 208]/256;
blueish=mcolor('blueish');

clf;
Edges=G.Edges; Nodes=G.Nodes;
for k=1:numedges(G)
    [~,x1,x2,x3]=G.fullEdge(k);
    ww=Edges.Weight(k)*2;
    plot3(x1,x2,x3,'color',blueish,'linewidth',ww);
    hold on;
    x1m=(x1(1)+x1(end))/2;
    x2m=(x2(1)+x2(end))/2;
    x3m=(x3(1)+x3(end))/2;
    if ~muteFlag
        text(x1m,x2m,x3m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')
    end
end
axis equal
xlim=get(gca,'xlim'); dx=diff(xlim)/30;

plot3(Nodes.x1,Nodes.x2,Nodes.x3,'o','color',blueish, 'markersize',10,'MarkerFaceColor',blueish)

if ~muteFlag
    lightgray=.95*[1 1 1];
    for k=1:numnodes(G)
        text(Nodes.x1(k)+dx,Nodes.x2(k)+dx,Nodes.x3(k)+dx,int2str(k),'fontsize',18,'horizontalalignment','center',...
            'edgecolor','k','background',lightgray)
    end
end

hold off
axis equal tight off
set(gcf,'color','w')