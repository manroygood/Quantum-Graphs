function Phi = hexOfHexes(opts)

arguments
    opts.nx = 10;
    opts.edgeLength=2;
    opts.L=1;
    opts.robinCoeff=0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end

% note that I interpret nx1 and nx2 as the number of cells in each
% direction, so we need one more row of vertices in each direction
nRings=opts.edgeLength-1;
nx1=2*opts.edgeLength+2;
nx2=nx1;
L=opts.L;
v1=L*[sqrt(3) 1]/2;
v2=L*[-sqrt(3) 1]/2;
v3=L*[0 1];
w1=v1-v2;
w2=v1+v3;


% edges pointing along vector v1.
% Note that this expression adds a row vector to a column vector to produce
% a rectangualar array.
v1Source=(1:nx1)+2*nx1*(0:nx2-1)';
v1Target=v1Source+nx1;
% edges pointed along vector v2.
v2Source=(2:nx1)+2*nx1*(0:nx2-1)';
v2Target=v2Source+nx1-1;
% edges pointed along vector v3:
v3Source = v1Target(1:end-1,:);
v3Target = v3Source+nx1;
x1=(1:nx1);
x2=(1:nx2);
[X2,X1]=meshgrid(x2,x1);X1=X1(:);X2=X2(:);

blueNodes=[X1 X2]*[w1; w2];
redNodes=blueNodes+v1;
blueX1=blueNodes(:,1);blueX1=reshape(blueX1,nx1,nx2);
blueX2=blueNodes(:,2);blueX2=reshape(blueX2,nx1,nx2);

redX1=redNodes(:,1);redX1=reshape(redX1,nx1,nx2);
redX2=redNodes(:,2);redX2=reshape(redX2,nx1,nx2);

allX1=zeros(nx1,2*nx2);
allX1(:,1:2:end)=blueX1;
allX1(:,2:2:end)=redX1;
X1=allX1(:);
X1=X1-mean(X1);

allX2=zeros(nx1,2*nx2);
allX2(:,1:2:end)=blueX2;
allX2(:,2:2:end)=redX2;
X2=allX2(:);
X2=X2-mean(X2);

nodes=[X1 X2];
nodes=nodes(2:end-1,:);

Edges=[v1Source(:) v1Target(:);
    v2Source(:) v2Target(:)
    v3Source(:) v3Target(:)];
Edges=sortrows(Edges);
Edges=Edges(2:end-1,:)-1;
source=Edges(:,1);
target=Edges(:,2);

PhiTemp=digraph(source,target);
radiusSquared = (1+3*nRings+3*nRings^2)*L^2;
keepers=X1.^2+X2.^2<radiusSquared+1e-9;
tossers=find(X1.^2+X2.^2>radiusSquared+1e-9);
PhiTemp=PhiTemp.rmnode(tossers);
nodes=nodes(keepers,:);
source=PhiTemp.Edges.EndNodes(:,1);
target=PhiTemp.Edges.EndNodes(:,2);
LVec = L*ones(size(source));

Phi = quantumGraph(source,target,LVec,'robinCoeff',opts.robinCoeff,'nXVec',opts.nx);

plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);