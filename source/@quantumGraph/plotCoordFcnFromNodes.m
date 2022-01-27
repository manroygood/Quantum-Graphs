function plotCoords = plotCoordFcnFromNodes(G,nodes)
if ismember('relinked', G.qg.Edges.Properties.VariableNames)
    relinked=G.qg.Edges.relinked;
else
    relinked=zeros(G.numedges,1);
end
nEdges=G.numedges;

plotCoords.x1Node = nodes(:,1);
plotCoords.x2Node = nodes(:,2);

plotCoords.x1Edge = cell(nEdges,1);
plotCoords.x2Edge = cell(nEdges,1);

for k=1:nEdges
    nodeStart=nodes(G.source(k),:);
    nodeEnd = nodes(G.target(k),:);
    if ~relinked(k) 
        plotCoords.x1Edge{k} = G.distributePlotCoords(nodeStart(1),nodeEnd(1),k);
        plotCoords.x2Edge{k} = G.distributePlotCoords(nodeStart(2),nodeEnd(2),k);
    else
        xx=G.distributePlotCoords(0,1,k);
        yy=xx.*(1-xx)/10;
        displacement=nodeEnd-nodeStart;
        r=norm(displacement); theta=angle(displacement(1)+1i*displacement(2));
        XY=[r* cos(theta) -r*sin(theta); r*sin(theta) r*cos(theta)]*[xx';yy'];
        plotCoords.x1Edge{k} = nodeStart(1)+XY(1,:)'; 
        plotCoords.x2Edge{k} = nodeStart(2)+XY(2,:)';
    end
end

if size(nodes,2)==3
    plotCoords.x3Node = nodes(:,3);
    plotCoords.x3Edge = cell(nEdges,1);
    for k=1:nEdges
        nodeStart=nodes(G.source(k),:);
        nodeEnd = nodes(G.target(k),:);
        plotCoords.x3Edge{k} = G.distributePlotCoords(nodeStart(3),nodeEnd(3),k);
    end
end