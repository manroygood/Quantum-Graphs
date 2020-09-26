function addUniformCoordinates(G,nxVec,ny)

nEdges=G.numedges;
nNodes=G.numnodes;

if length(nxVec)==1
    nxVec=nxVec*ones(nEdges,1);
end

if ~exist('ny','var')
    ny=1;
end

assert(length(nxVec)==nEdges,'quantumGraph:nxMismatch','Length of nxVec must match number of edges');
G.qg.Edges.nx=nxVec(:);

% create containers for the x-coordinates
G.qg.Edges.x = cell(nEdges,1);
G.qg.Edges.y = cell(nEdges,ny);
G.qg.Edges.dx=zeros(nEdges,1);
for k=1:nEdges
    lastNode=G.qg.Edges.EndNodes(k,2);
    isDirichlet=isnan(G.qg.Nodes.robinCoeff(lastNode));
    
    if ~isDirichlet
        G.qg.Edges.dx(k)=G.qg.Edges.L(k) ./ G.qg.Edges.nx(k);
        G.qg.Edges.x{k} = G.qg.Edges.dx(k)*((1:G.qg.Edges.nx(k))-1/2)';
    else
        dx=G.Edges.L(k) ./ (1/2+G.Edges.nx(k));
        G.qg.Edges.dx(k)=dx;
        G.qg.Edges.x{k} = ((1:G.Edges.nx(k))-1/2)*dx;
    end
    G.qg.Edges.y{k} = nan(nxVec(k),ny);
end

% Create the Ghost matrices at each node. These are the matrices that give
% you the value of the function of the point at a distance dx(j)/2 beyond
% the node. This is then used to interpolate the function value at the node
% and to compute first or second derivatives at that point.
 
G.qg.Nodes.ghostMatrix =cell(nNodes,1);
for j=1:nNodes
    if ~isnan(G.qg.Nodes.robinCoeff(j)) % Test for Dirichlet
        alpha = G.qg.Nodes.robinCoeff(j);
        [fullDegree,~,allEdges]=fullDegreeEtc(G,j);
        lastRow=G.qg.Edges.Weight(allEdges)./G.qg.Edges.dx(allEdges);
        LHM=diag(ones(fullDegree-1,1),1);
        LHM(:,1)=-1;
        LHM(fullDegree,:) = lastRow+alpha/fullDegree;
        RHM=diag(-ones(fullDegree-1,1),1);
        RHM(:,1)=1;
        RHM(fullDegree,:) = lastRow-alpha/fullDegree;
        G.qg.Nodes.ghostMatrix{j}=LHM\RHM;
    end
end
