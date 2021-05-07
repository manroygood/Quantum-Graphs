function plotGraphLayout(G)
% Plots a graph G over its skeleton. 
% Graph must have Nodes.x1 and Nodes.x2 defined
% see addTadpolePlotCoords for an example
creamcolor=[255 253 208]/256;
clf;hold on
Edges=G.Edges; Nodes=G.Nodes;
for k=1:numedges(G)
    n1=Edges.EndNodes(k,1);
    n2=Edges.EndNodes(k,2);
    if G.isUniform
        x1=[Nodes.x1(n1); Edges.x1{k}; Nodes.x1(n2)];
        x2=[Nodes.x2(n1); Edges.x2{k}; Nodes.x2(n2)];
    else
        x1 = Edges.x1{k};
        x2 = Edges.x2{k};
    end
    ww=Edges.Weight(k)*2;
    plot(x1,x2,'color','b','linewidth',ww);
    x1m=x1(round(length(x1)/2));
    x2m=x2(round(length(x1)/2));
    text(x1m,x2m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')
end
axis equal
xlim=get(gca,'xlim'); dx=diff(xlim)/30;

plot(Nodes.x1,Nodes.x2,'bo','markersize',10,'MarkerFaceColor','b')

lightgray=.95*[1 1 1];
for k=1:numnodes(G)
    text(Nodes.x1(k)+dx,Nodes.x2(k)+dx,int2str(k),'fontsize',18,'horizontalalignment','center',...
        'edgecolor','k','background',lightgray)
end

hold off
axis equal off
set(gcf,'color','w')

