function Phi = rectangularArray(opts)

arguments
    opts.nx1=5;
    opts.nx2=3;
    opts.Lx1=1;
    opts.Lx2=1;
    opts.robinCoeff=0;
end

nx1=opts.nx1; Lx1 = opts.Lx1;
nx2=opts.nx2; Lx2 = opts.Lx2;

% edges pointing to the right
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
LVec = sqrt((X1(target)-X1(source)).^2+(X2(target)-X2(source)).^2);
Phi = quantumGraph(source,target,LVec,'robinCoeff',opts.robinCoeff,'nXVec',opts.nx1);


plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);