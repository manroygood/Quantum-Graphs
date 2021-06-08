function plotOnGraph2D(G,myColor)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

if nargin==1
    myColor=mcolor('blueish');
end
nEdges=numedges(G);
Edges=G.Edges; 
for k=1:nEdges
    [x1,x2,y]=G.fullEdge(k);

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

[x1Range,x2Range,yMin,yMax,yRange]=plotRange(G);
xRange = min(x1Range,x2Range);
zRange= diff(get(gca, 'ZLim'));

set(gca,'DataAspectRatio',[xRange xRange 1.25*zRange])
if yRange == 0
    yRange = 10^(-16);
end
set(gca,'ZLim',[(yMin-yRange/4), (yMax +yRange/4)])