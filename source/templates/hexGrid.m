function Phi = hexGrid(opts)

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

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);
plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);

