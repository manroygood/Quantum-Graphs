function Phi = rectangularArray(opts)

arguments
    opts.nx1=4;
    opts.nx2=3;
    opts.L=1;
    opts.robinCoeff=0;
    opts.nX=12;
    opts.Discretization='Uniform';
end

% note that I interpret nx1 and nx2 as the number of cells in each
% direction, so we need one more row of vertices in each direction
nx1=opts.nx1; 
nx2=opts.nx2; 
L=opts.L;

% edges pointing to the right. 
% Note that this expression adds a row vector to a column vector to produce
% a rectangualar array.
horizontalSource=(1:nx1-1)+nx1*(0:nx2-1)';
horizontalTarget=(2:nx1)+nx1*(0:nx2-1)';
% edges pointed upward
verticalSource=(1:nx1)+nx1*(0:nx2-2)';
verticalTarget=(1:nx1)+nx1*(1:nx2-1)';
x1=(3*mod(n,2*(nx1+1))+mod(n,2)-3*(nx1+1)*rowParity); x1= x1-mean(x1);
x2=(1:nx2)*Lx2; x2 = x2 - mean(x2);
[X2,X1]=meshgrid(x2,x1);X1=X1(:);X2=X2(:);
nodes=[X1 X2];

Edges=[horizontalSource(:) horizontalTarget(:);
         verticalSource(:)   verticalTarget(:) ];
LVec=[Lx1*ones(size(horizontalSource(:))); Lx2*ones(size(verticalSource(:)))];
[Edges,index]=sortrows(Edges);
LVec=LVec(index);
source=Edges(:,1);
target=Edges(:,2);


Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);
plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);

