function addCoordinatesChebyshev(G,opts)

nEdges=G.numedges;
nNodes=G.numnodes;
LVec=G.L;
nxVec = opts.nxVec;

if isscalar(nxVec)
    nxVec=nxVec*ones(nEdges,1);
end

assert(length(nxVec)==nEdges,'quantumGraph:nxMismatch','Length of nxVec must match number of edges');
G.qg.Edges.nx=nxVec(:);

% create containers for the x-coordinates
G.qg.Edges.x = cell(nEdges,1);


for k=1:nEdges
    nx=nxVec(k);
    s = chebptsSecondKind(nx);
    if isinf(G.L(k))
        L = G.stretch(k);
        G.qg.Edges.x{k} = sinh(L*(1-sqrt(1-s)));
    else
        G.qg.Edges.x{k} = LVec(k)*s;
    end
    G.qg.Edges.y{k} = nan(nx+2,1);
end
G.qg.Nodes.y=nan(nNodes,1);