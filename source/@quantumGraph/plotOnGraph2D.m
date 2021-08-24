function plotOnGraph2D(G,myColor)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined

if nargin==1
    myColor=mcolor('blueish');
end
nEdges=numedges(G);
Edges=G.Edges;
for k=1:nEdges
    [y,x1,x2]= G.fullEdge(k);
    ww=Edges.Weight(k)*2;
    lh=plot3(x1,x2,zeros(size(x1)),'color',.7*[1 1 1],'linewidth',ww);
    hold on
    plot3(x1,x2,y,'color',myColor,'linewidth',ww)
    
    % This bit prevents some weird visual artifacts that occur if an eigenfunction
    % vanishes identically on an edge
    if all(abs(Edges.y{k}) < 1e-6)
        delete(lh);
    else
        yS=y(1:end-1).*y(2:end);
        signChanges=find(yS<0); nsC=length(signChanges);
        if nsC>0
            s = y(signChanges)./(y(signChanges)-y(signChanges+1));
            x1s=x1(signChanges)+ s.*(x1(signChanges+1)-x1(signChanges));
            x2s=x2(signChanges)+ s.*(x2(signChanges+1)-x2(signChanges));
            plot3(x1s,x2s,zeros(nsC,1),'o','color',myColor,'markerfacecolor',myColor)
        end
    end
end
hold off

[x1Range,x2Range,yMin,yMax,yRange]=plotRange(G);
xRange = min(x1Range,x2Range);
zRange= diff(get(gca, 'ZLim'));

set(gca,'DataAspectRatio',[xRange xRange 1.25*zRange])
set(gca,'ZLim',[(yMin-yRange/4), (yMax +yRange/4)])