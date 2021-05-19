function Phi = delaunaySquare(opts)

arguments
opts.n  {mustBeNumeric} = 4;
opts.nX {mustBeNumeric} = 40;
opts.robinCoeff = 0;
end
n=opts.n;

bottomside = [ [0;rand(n-1,1)] zeros(n,1)       ];
rightside =  [ones(n,1)        [0;rand(n-1,1)]  ];
topside =    [[1; rand(n-1,1)] ones(n,1)        ];
leftside =   [zeros(n,1)       [1; rand(n-1,1)] ];
inside = rand((n-1)^2,2);

square=[bottomside;rightside;topside;leftside;inside];
x=square(:,1);y=square(:,2);

DT=delaunay(x,y);
segments1=sort(DT(:,[1 2]),2);
segments2=sort(DT(:,[2 3]),2);
segments3=sort(DT(:,[3 1]),2);
segments=[segments1; segments2; segments3];
segments=unique(segments,'rows');
source= segments(:,1); target= segments(:,2);
nodes=[x y];

LVec = sqrt((x(target)-x(source)).^2+(y(target)-y(source)).^2);
Phi = quantumGraph(source,target,LVec,'robinCoeff',opts.robinCoeff,'nxVec',opts.nX);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);