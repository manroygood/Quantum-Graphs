function addUniformCoordinates(G,nxVec,ny)

nEdges=G.numedges;
nNodes=G.numnodes;

if ~exist('ny','var')
    ny=1;
end

% If length(nxVec)==1, then it is interpreted to be the density of points
% per unit length on each edge
% Add two to nxVec for the two ghost points
if length(nxVec)==1
    nxVec=ceil(nxVec*G.L);
end

assert(length(nxVec)==nEdges,'quantumGraph:nxMismatch','Length of nxVec must match number of edges');
G.qg.Edges.nx=nxVec(:);

% create containers for the x-coordinates
G.qg.Edges.x = cell(nEdges,1);
G.qg.Edges.y = cell(nEdges,ny);
G.qg.Edges.dx=zeros(nEdges,1);
nx=G.nx;
for k=1:nEdges
    G.qg.Edges.dx(k)=G.L(k) ./(nx(k));
    G.qg.Edges.x{k} = G.dx(k)*((0:(nx(k)+1))-1/2)';
    G.qg.Edges.y{k} = nan(nxVec(k),ny);
end
G.qg.Nodes.y=nan(nNodes,1);