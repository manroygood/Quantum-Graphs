function plotGraphLayout2D(G,muteFlag)

creamcolor=mcolor('eggshell');
blueish=mcolor('blueish');
reddish=mcolor('reddish');
lightgray=mcolor('lightgray');
clf;hold on
if ismember('relinked', G.qg.Edges.Properties.VariableNames)
    relinked=G.qg.Edges.relinked;
else
    relinked=zeros(G.numedges,1);
end
Edges=G.Edges; Nodes=G.Nodes;
for k=1:numedges(G)
    [~,x1,x2]=G.fullEdge(k);
    ww=Edges.Weight(k)*2;
    nextLine=plot(x1,x2,'color',blueish,'linewidth',ww);
    if relinked(k); set(nextLine,'color',reddish);end
    x1m=x1(round(length(x1)/2));
    x2m=x2(round(length(x1)/2));
    if ~muteFlag
        text(x1m,x2m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')
    end
end
axis equal
xlim=get(gca,'xlim'); dx=diff(xlim)/30;

plot(Nodes.x1,Nodes.x2,'o','color',blueish,'markersize',10,'MarkerFaceColor',blueish)

if ~muteFlag
    
    for k=1:numnodes(G)
        text(Nodes.x1(k)+dx,Nodes.x2(k)+dx,int2str(k),'fontsize',18,'horizontalalignment','center',...
            'edgecolor','k','background',lightgray)
    end
end

hold off
axis equal off tight
set(gcf,'color','w')