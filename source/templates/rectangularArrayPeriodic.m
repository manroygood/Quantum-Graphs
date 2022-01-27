function [Phi,PhiExtended,extensionMap] = rectangularArrayPeriodic(opts)

arguments
    opts.nx1=5;
    opts.nx2=3;
    opts.Lx1=1;
    opts.Lx2=1;
    opts.robinCoeff=0;
    opts.nX=20;
    opts.Discretization='Uniform';
end

nx1=opts.nx1; Lx1 = opts.Lx1;
nx2=opts.nx2; Lx2 = opts.Lx2;

% edges pointing to the right.
% Note that this expression adds a row vector to a column vector to produce
% a rectangualar array.
horizontalSource=(1:nx1-1)+nx1*(0:nx2-1)';
horizontalTarget=(2:nx1)+nx1*(0:nx2-1)';
% edges pointed upward
verticalSource=(1:nx1)+nx1*(0:nx2-2)';
verticalTarget=(1:nx1)+nx1*(1:nx2-1)';

rightEdge = nx1*(1:nx2);
leftEdge = nx1*(0:nx2-1)+1;

bottomEdge = 1:nx1;
topEdge = bottomEdge + (nx2-1)*nx1;



x1=(1:nx1)*Lx1; x1 = x1 - mean(x1);
x2=(1:nx2)*Lx2; x2 = x2 - mean(x2);
[X2,X1]=meshgrid(x2,x1);X1=X1(:);X2=X2(:);
nodes=[X1 X2];

Edges=[horizontalSource(:) horizontalTarget(:);
    verticalSource(:)   verticalTarget(:);
    rightEdge(:)         leftEdge(:);
    topEdge(:)       bottomEdge(:)];


LVec=[Lx1*ones(size(horizontalSource(:)));
    Lx2*ones(size(verticalSource(:)));
    Lx1*ones(nx2,1)
    Lx2*ones(nx1,1)];
[Edges,index]=sortrows(Edges);
LVec=LVec(index);
source=Edges(:,1);
target=Edges(:,2);

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);

% Construct the extended matrix
x1max=max(nodes(:,1));
x2max=max(nodes(:,2));
nodes=[nodes;
    x1' (x2max+Lx2)*ones(nx1,1); ...
    (x1max+Lx1)*ones(nx2,1) x2';
    (x1max+Lx1) (x2max+Lx2)];

topEdgeExtra = topEdge+nx1;
rightEdgeExtra = topEdgeExtra(end)+(1:nx2);
topRightNode = (nx1+1)*(nx2+1);

EdgesX=[horizontalSource(:) horizontalTarget(:);
    verticalSource(:)   verticalTarget(:);
    rightEdge(:)   rightEdgeExtra(:);
    topEdge(:)     topEdgeExtra(:);
    topEdgeExtra(1:end-1)' topEdgeExtra(2:end)'
    topEdgeExtra(end) topRightNode;
    rightEdgeExtra(1:end-1)' rightEdgeExtra(2:end)'
    rightEdgeExtra(end) topRightNode];

LVec=[Lx1*ones(size(horizontalSource(:)));
    Lx2*ones(size(verticalSource(:)));
    Lx1*ones(nx2,1);
    Lx2*ones(nx1,1);
    Lx1*ones(nx1,1);
    Lx2*ones(nx2,1)];
[EdgesX,index]=sortrows(EdgesX);
LVec=LVec(index);
source=EdgesX(:,1);
target=EdgesX(:,2);

PhiExtended = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
PhiExtended.addPlotCoords(plotCoordFcn);

% Map the edges of the extended graph to the edges of the periodic graph
nodeMap=zeros(PhiExtended.numnodes,1);
nNodes=Phi.numnodes;

nodeMap(1:nNodes)=(1:nNodes)';
nodeMap(nNodes+1:nNodes+nx1)=(1:nx1)';
nodeMap(nNodes+nx1+1:nNodes+nx1+nx2)=1+(0:nx2-1)*nx1;
nodeMap(end)=1;

edgeMap=zeros(PhiExtended.numedges,1);
edgeBack=nodeMap(EdgesX);
for j=1:PhiExtended.numedges
    edgeMap(j)=find(all(Edges==edgeBack(j,:),2));
end

extensionMap.nodes=nodeMap;
extensionMap.edges=edgeMap;
