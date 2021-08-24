function Phi = matlabLogo(opts)

arguments
    opts.nx1=3;
    opts.Lx1=1;
    opts.robinCoeff=0;
    opts.nX=20;
    opts.Discretization='Uniform';
    opts.dirichletFlag=false;
    opts.weight=1;
end

% note that I interpret nx1 and nx1 as the number of cells in each
% direction, so we need one more row of vertices in each direction
nx1=1+2*opts.nx1; Lx = opts.Lx1;

% edges pointing to the right.
% Note that this expression adds a row vector to a column vector to produce
% a rectangualar array.
horizontalSource=(1:nx1-1)+nx1*(0:nx1-1)';
horizontalTarget=(2:nx1)+nx1*(0:nx1-1)';
% edges pointed upward
verticalSource=(1:nx1)+nx1*(0:nx1-2)';
verticalTarget=(1:nx1)+nx1*(1:nx1-1)';
x1=(1:nx1)*Lx; x1 = x1 - mean(x1);
x2=(1:nx1)*Lx; x2 = x2 - mean(x2);
[X2,X1]=meshgrid(x2,x1);X1=X1(:);X2=X2(:);
nodes=[X1 X2];


Edges=[horizontalSource(:) horizontalTarget(:);
    verticalSource(:)   verticalTarget(:) ];
Edges=sortrows(Edges);


% Code to toss out the bottom left quarter, to get an L-shaped membrane
tossers= X1<0 & X2<0;
nn=1:length(X1);
nKeep=nn(~tossers);
nToss=nn(tossers);
for k=1:length(Edges)
    if any(Edges(k,1)==nToss) || any(Edges(k,2)==nToss)
        Edges(k,:)=nan;
    end
end
Edges=Edges(~isnan(Edges(:,1)),:);
for i=1:length(Edges)
    for j=1:2
        Edges(i,j)=find(Edges(i,j)==nKeep);
    end
end

source=Edges(:,1);
target=Edges(:,2);
nodes=nodes(~tossers,:);
nNodes=length(nodes);
% Find all the boundary elements and set their boundary condition to
% Dirichlet
opts.robinCoeff=opts.robinCoeff*ones(nNodes,1);
for k=1:nNodes
    deg = sum(source==k | target==k);
    if deg<4 
        opts.robinCoeff(k)=nan;
    end
end
opts.robinCoeff((1+opts.nx1)^2)=nan;


L = norm(nodes(target(1),:)-nodes(source(1),:));
LVec = L*ones(length(Edges),1);
nodes = nodes/L;

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
    'Discretization',opts.Discretization,'Weight',opts.weight);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);

Phi.addPlotCoords(plotCoordFcn);

