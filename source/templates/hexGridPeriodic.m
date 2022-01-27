function  [Phi,PhiExtended,extensionMap] = hexGridPeriodic(opts)

arguments
    opts.nx1=4;
    opts.nx2=3;
    opts.L=1;
    opts.robinCoeff=0;
    opts.nX=12;
    opts.Discretization='Uniform';
end

assert(~mod(opts.nx1,2),'nx1 must be even.')

% note that I interpret nx1 and nx2 as the number of cells in each
nx1=opts.nx1;
nx2=opts.nx2;
L=opts.L;


npts=2*(nx1+1)*(nx2+1)-2;



nn=(1:npts)';
rowParity=mod(floor(nn/(nx1+1)),2);
x1=(3*mod(nn,2*(nx1+1))+mod(nn,2)-3*(nx1+1)*rowParity)*L/2;x1=x1-mean(x1);
x2=L*sqrt(3)/2*floor(nn/(nx1+1));x2=x2-mean(x2);
nodes=[x1 x2];

horizontalSource=setdiff(1:2:npts,(2*(nx1+1)-1:2*(nx1+1):npts))';
upLeftSource=(1:2:npts-nx1-1)';
upRightSource=(2:2:npts-nx1-2)';

Edges=[horizontalSource horizontalSource+1
    upLeftSource     upLeftSource+nx1+1
    upRightSource    upRightSource+nx1+1];
Edges=Edges(all(Edges<=npts,2),:);

Edges=sortrows(Edges);



LVec=L;
source=Edges(:,1);
target=Edges(:,2);

PhiExtended = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);
plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
PhiExtended.addPlotCoords(plotCoordFcn);

bottomEdge=[1:nx1-1 nx1+2:2*nx1];
topEdge=bottomEdge+2*(nx1+1)*nx2;
leftEdge=(nx1+1)*(2:2*nx2-1);
rightEdge=leftEdge+nx1;
redCornerKeep=(nx1+1)*2*nx2;
redCornersRemove=[nx1 npts-nx1];
yellowCornersRemove=[1+2*nx1 npts-nx1+1];
yellowCornerKeep=nx1+1;
nodesRemove=[rightEdge,topEdge,redCornersRemove,yellowCornersRemove];
nodesPreimage=[leftEdge bottomEdge redCornerKeep*[1 1] yellowCornerKeep*[1 1]];
nodesBoundary=union(nodesRemove,nodesPreimage);
nodesInterior=setdiff(1:npts,nodesBoundary);
nodesKeep = setdiff(1:npts,nodesRemove);

nodeMap=(1:npts)';
nodeMap(nodesRemove)=nodesPreimage;

nEdges=PhiExtended.numedges;
edgeKeepFlag=ones(nEdges,1);
edgeMap=(1:nEdges)';
EdgesNew=Edges;

relinked=zeros(nEdges,1);

% Relink the vertices pointing from the interior to the right edge to point
% to the left edge
set1=PhiExtended.findEdgesBetweenNodeSets(nodesInterior,rightEdge);
EdgesNew(set1,2)=nodeMap(Edges(set1,2));
relinked(set1)=1;
% Relink the vertices pointing from the interior to the top edge to point
% to the bottom edge
set1=PhiExtended.findEdgesBetweenNodeSets(nodesInterior,topEdge);
EdgesNew(set1,2)=nodeMap(Edges(set1,2));
relinked(set1)=1;
% Build a map from edges along the right to edges along the left
set1=PhiExtended.findEdgesBetweenNodeSets(rightEdge,rightEdge);
set2=PhiExtended.findEdgesBetweenNodeSets(leftEdge,leftEdge);
edgeKeepFlag(set1)=0;
edgeMap(set1)=set2;
% Build a map from edges along the top to edges along the bottom
set1=PhiExtended.findEdgesBetweenNodeSets(topEdge,topEdge);
set2=PhiExtended.findEdgesBetweenNodeSets(bottomEdge,bottomEdge);
edgeKeepFlag(set1)=0;
edgeMap(set1)=set2;


% Combine the five duplicated edges involving the red and yellow corners
% (see figure named XXXXXX in this directory for visual explanation)
edge1=PhiExtended.findEdgesBetweenNodeSets(topEdge,redCornersRemove);
edge2=PhiExtended.findEdgesBetweenNodeSets(bottomEdge,redCornersRemove);
edgeKeepFlag(edge1)=0;
EdgesNew(edge2,2)=redCornerKeep; 
relinked(edge2)=1;
edgeMap(edge1)=edge2;

edge1=PhiExtended.findEdgesBetweenNodeSets(rightEdge,redCornersRemove);
edge2=PhiExtended.findEdgesBetweenNodeSets(leftEdge,redCornerKeep);
edgeKeepFlag(edge1)=0;
edgeMap(edge1)=edge2;

edge1=PhiExtended.findEdgesBetweenNodeSets(yellowCornersRemove,topEdge);
edge2=PhiExtended.findEdgesBetweenNodeSets(yellowCornerKeep,bottomEdge);
edgeKeepFlag(edge1)=0;
edgeMap(edge1)=edge2;

edge1=PhiExtended.findEdgesBetweenNodeSets(yellowCornersRemove,rightEdge);
edge2=PhiExtended.findEdgesBetweenNodeSets(yellowCornerKeep,leftEdge);
edgeKeepFlag(edge1)=0;
edgeMap(edge1)=edge2;

edge1=PhiExtended.findEdgesBetweenNodeSets(redCornersRemove,yellowCornersRemove);
edge2=PhiExtended.findEdgesBetweenNodeSets(redCornerKeep,yellowCornersRemove);
edgeKeepFlag(edge1)=0;
EdgesNew(edge2,2) =yellowCornerKeep;
relinked(edge2)=1;
edgeMap(edge1)=edge2;

edgesKeep=find(edgeKeepFlag);
EdgesNew=EdgesNew(find(edgeKeepFlag),:); %#ok<FNDSB> 

for j=1:2
    for i=1:length(EdgesNew)
        EdgesNew(i,j)=find(EdgesNew(i,j)==nodesKeep);
    end
end
[EdgesNew,index]=sortrows(EdgesNew);


for i=1:nEdges
    edgeMap(i)=find(edgeMap(i)==edgesKeep(index));
end


for i=1:length(nodeMap)
    nodeMap(i)=find(nodeMap(i)==nodesKeep);
end
source=EdgesNew(:,1); target=EdgesNew(:,2);
Phi=quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
                 'Discretization',opts.Discretization);

nodes=nodes(nodesKeep,:); %nodes=nodes-mean(nodes);
relinked = relinked(find(edgeKeepFlag)); %#ok<FNDSB> 
relinked = relinked(index);
Phi.assignDataToEdges(relinked);
plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);


extensionMap.nodes=nodeMap;
extensionMap.edges=edgeMap;
end
