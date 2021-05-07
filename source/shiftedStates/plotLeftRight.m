function plotLeftRight(u,G,dPML,mycolor)

G.column2graph(u);
[x,~,y]=G.fullEdge(1);
c=plot(-x,abs(y).^2);
if exist('mycolor','var'); set(c,'color',mycolor);end
hold on
for j=2:numedges(G)
    [~,~,y]=G.fullEdge(j);
    c=plot(x,abs(y).^2);
    if exist('mycolor','var'); set(c,'color',mycolor);end
end
if exist('dPML','var')
    L=max(x)-dPML;
    set(gca,'xlim',L*[-1 1]);
end
hold off