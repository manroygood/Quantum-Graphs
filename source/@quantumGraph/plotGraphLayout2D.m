function plotGraphLayout2D(G)
creamcolor=[255 253 208]/256;
blueish=mcolor('blueish');
clf;hold on
Edges=G.Edges; Nodes=G.Nodes;
for k=1:numedges(G)
   [x1,x2,~]=G.fullEdge(k);
   ww=Edges.Weight(k)*2;
   plot(x1,x2,'color',blueish,'linewidth',ww);
   x1m=x1(round(length(x1)/2));
   x2m=x2(round(length(x1)/2));
   text(x1m,x2m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')
end
axis equal
xlim=get(gca,'xlim'); dx=diff(xlim)/30;

plot(Nodes.x1,Nodes.x2,'o','color',blueish,'markersize',10,'MarkerFaceColor',blueish)

lightgray=.95*[1 1 1];
for k=1:numnodes(G)
    text(Nodes.x1(k)+dx,Nodes.x2(k)+dx,int2str(k),'fontsize',18,'horizontalalignment','center',...
        'edgecolor','k','background',lightgray)
end

hold off
axis equal off
set(gcf,'color','w')