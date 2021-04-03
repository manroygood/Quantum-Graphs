function plotOnGraph(G,myColor)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined
% see addTadpolePlotCoords for an example

if nargin==1
    myColor='b';
end
nEdges=numedges(G);
Edges=G.Edges; Nodes=G.Nodes;
for k=1:nEdges
    n1=Edges.EndNodes(k,1);
    n2=Edges.EndNodes(k,2);
    x1=[Nodes.x1(n1); Edges.x1{k}; Nodes.x1(n2)];
    x2=[Nodes.x2(n1); Edges.x2{k}; Nodes.x2(n2)];
    y=[Nodes.y(n1); Edges.y{k}; Nodes.y(n2)];
    ww=Edges.Weight(k)*2;
    lh=plot3(x1,x2,zeros(size(x1)),'color',.7*[1 1 1],'linewidth',ww);
    
    hold on
    % This bit prevents some weird visual artifacts that occur if an eigenfunction
    % vanishes identically on an edge
    if all(abs(Edges.y{k}) < 1e-6)
        delete(lh);
    end
    plot3(x1,x2,y,'color',myColor,'linewidth',ww)
end

hold off

ymax=-10;
ymin=0;
for k=1:nEdges
    ymax=max(ymax,max(Edges.y{k}));
    ymin=min(ymin,min(Edges.y{k}));
end
yrange=ymax-ymin;

set(gca, 'DataAspectRatio', ...
    [repmat(min(diff(get(gca, 'XLim')), diff(get(gca, 'YLim'))), [1 2]) 1.25*diff(get(gca, 'ZLim'))])
set(gca,'ZLim',[(ymin-yrange/4), (ymax +yrange/4)])