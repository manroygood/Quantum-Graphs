function addCoordinatesChebyshev(G,nxVec,ny)

nEdges=G.numedges;
nNodes=G.numnodes;
LVec=G.L;

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

for k=1:nEdges
    nx=nxVec(k);
    G.qg.Edges.x{k} = LVec(k)*chebptsSecondKind(nx);
    G.qg.Edges.y{k} = nan(nx,ny);
end
G.qg.Nodes.y=nan(nNodes,1);