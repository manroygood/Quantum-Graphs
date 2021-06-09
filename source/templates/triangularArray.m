function Phi = triangularArray(opts)

arguments
    opts.nx1=5;
    opts.nx2=3;
    opts.v1=[1 0];
    opts.v2=[1 sqrt(3)]/2;
    opts.robinCoeff=0;
end

% note that I interpret nx1 and nx2 as the number of cells in each
% direction, so we need one more row of vertices in each direction
nx1=1+opts.nx1; v1 = opts.v1;
nx2=1+opts.nx2; v2 = opts.v2;

assert(abs(det([v1; v2]))>1e-5,'The area of the period triangle is close to zero')

% edges pointing along vector v1. 
% Note that this expression adds a row vector to a column vector to produce
% a rectangualar array.
v1Source=(1:nx1-1)+nx1*(0:nx2-1)';
v1Target=(2:nx1)+nx1*(0:nx2-1)';
% edges pointed along vector v2.
v2Source=(1:nx1)+nx1*(0:nx2-2)';
v2Target=(1:nx1)+nx1*(1:nx2-1)';
% edges pointed along vector v3:
v3Source = 1 + (1:nx1-1)+nx1*(0:nx2-2)';
v3Target = nx1 + (1:nx1-1)+nx1*(0:nx2-2)';
x1=(1:nx1); x1 = x1 - mean(x1);
x2=(1:nx2); x2 = x2 - mean(x2);
[X2,X1]=meshgrid(x2,x1);X1=X1(:);X2=X2(:);

nodes=[X1 X2]*[v1; v2];

Edges=[v1Source(:) v1Target(:);
       v2Source(:) v2Target(:) 
       v3Source(:) v3Target(:)];
Edges=sortrows(Edges);
source=Edges(:,1);
target=Edges(:,2);
LVec = sqrt((X1(target)-X1(source)).^2+(X2(target)-X2(source)).^2);
Phi = quantumGraph(source,target,LVec,'robinCoeff',opts.robinCoeff,'nXVec',opts.nx1);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);