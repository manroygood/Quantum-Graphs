function addCoordinatesUniform(G,opts)

nEdges=G.numedges;
nNodes=G.numnodes;
nxVec = opts.nxVec;


% If length(nxVec)==1, then it is interpreted to be the density of points
% per unit length on each edge
% The definition of nxVec does not include the two ghost points
if isscalar(nxVec)
    if all(~isinf(G.L))
        nxVec = ceil(nxVec*G.L);
    elseif all(isinf(G.L))
        nxVec = nxVec*ones(nEdges,1);
    elseif all(isnan(G.L))
        nxVec = nxVec*ones(nEdges,1);
    else
        if nEdges>1
            nxVec = ceil(nxVec*G.L);
            nxVec(isinf(nxVec))=max(nxVec(~isinf(nxVec)));
        end
    end
end

assert(length(nxVec)==nEdges,'quantumGraph:nxMismatch','Length of nxVec must match number of edges');
G.qg.Edges.nx=nxVec(:);

% create containers for the x-coordinates
G.qg.Edges.x = cell(nEdges,1);
G.qg.Edges.y = cell(nEdges,1);
nx=G.nx;
for k=1:nEdges
    if isinf(G.L(k))
        n = nx(k); ds = 1/n;
        L = G.stretch(k);
        s = linspace(-ds/2,1+ds/2,n+2)';
        G.qg.Edges.x{k} = sinh(L*s);
    else
        dx=G.L(k)/nx(k);
        G.qg.Edges.x{k} = dx*((0:(nx(k)+1))-1/2)';
    end
    G.qg.Edges.y{k} = nan(nxVec(k)+2,1);  % This includes the two ghost points
end
G.qg.Nodes.y=nan(nNodes,1);