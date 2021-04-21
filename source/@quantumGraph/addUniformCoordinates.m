function addUniformCoordinates(Phi,nxVec,ny)

nEdges=Phi.numedges;
nNodes=Phi.numnodes;

if ~exist('ny','var')
    ny=1;
end

% If length(nxVec)==1, then it is interpreted to be the density of points
% per unit length on each edge
if length(nxVec)==1
    nxVec=ceil(nxVec*Phi.L); 
end
    

assert(length(nxVec)==nEdges,'quantumGraph:nxMismatch','Length of nxVec must match number of edges');
Phi.qg.Edges.nx=nxVec(:);

% create containers for the x-coordinates
Phi.qg.Edges.x = cell(nEdges,1);
Phi.qg.Edges.y = cell(nEdges,ny);
Phi.qg.Edges.dx=zeros(nEdges,1);
nx=Phi.nx;
for k=1:nEdges
    lastNode=Phi.EndNodes(k,2);
    
    if ~isDirichlet(Phi,lastNode)
        Phi.qg.Edges.dx(k)=Phi.L(k) ./nx(k);
        Phi.qg.Edges.x{k} = Phi.dx(k)*((1:nx(k))-1/2)';
    else
        dx=Phi.Edges.L(k) ./ (1/2+nx(k));
        Phi.qg.Edges.dx(k)=dx;
        Phi.qg.Edges.x{k} = ((1:nx(k))-1/2)'*dx;
    end
    Phi.qg.Edges.y{k} = nan(nxVec(k),ny);
end

% Create the Ghost matrices at each node. These are the matrices that give
% you the value of the function of the point at a distance dx(j)/2 beyond
% the node. This is then used to interpolate the function value at the node
% and to compute first or second derivatives at that point.
 
Phi.qg.Nodes.ghostMatrix =cell(nNodes,1);
for j=1:nNodes
    if ~isDirichlet(Phi,j)
        alpha = Phi.robinCoeff(j);
        [fullDegree,~,allEdges]=fullDegreeEtc(Phi,j);
        lastRow=Phi.weight(allEdges)./Phi.dx(allEdges);
        LHM=diag(ones(fullDegree-1,1),1);
        LHM(:,1)=-1;
        LHM(fullDegree,:) = lastRow+alpha/fullDegree;
        RHM=diag(-ones(fullDegree-1,1),1);
        RHM(:,1)=1;
        RHM(fullDegree,:) = lastRow-alpha/fullDegree;
        Phi.qg.Nodes.ghostMatrix{j}=LHM\RHM;
    end
end
