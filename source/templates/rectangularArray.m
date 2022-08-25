function Phi = rectangularArray(opts)

arguments
    opts.nx1=5;
    opts.nx2=3;
    opts.Lx1=1;
    opts.Lx2=1;
    opts.robinCoeff=0;
    opts.nX=20;
    opts.Discretization='Uniform';
end

% note that I interpret nx1 and nx2 as the number of cells in each
% direction, so we need one more row of vertices in each direction
nx1=1+opts.nx1; Lx1 = opts.Lx1;
nx2=1+opts.nx2; Lx2 = opts.Lx2;

% edges pointing to the right. 
% Note that this expression adds a row vector to a column vector to produce
% a rectangualar array.
horizontalSource=(1:nx1-1)+nx1*(0:nx2-1)';
horizontalTarget=(2:nx1)+nx1*(0:nx2-1)';
% edges pointed upward
verticalSource=(1:nx1)+nx1*(0:nx2-2)';
verticalTarget=(1:nx1)+nx1*(1:nx2-1)';
x1=(1:nx1)*Lx1; x1 = x1 - mean(x1);
x2=(1:nx2)*Lx2; x2 = x2 - mean(x2);
[X2,X1]=meshgrid(x2,x1);X1=X1(:);X2=X2(:);
nodes=[X1 X2];

Edges=[horizontalSource(:) horizontalTarget(:);
         verticalSource(:)   verticalTarget(:) ];
Edges=sortrows(Edges);
source=Edges(:,1);
target=Edges(:,2);

L = norm(nodes(target(1),:)-nodes(source(1),:));
LVec = L*ones(length(Edges),1);
nodes = nodes/L;

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);

Phi.addPlotCoords(plotCoordFcn);
