function addDependentCoords(G,nDependent)

if ~exist('nDep','var')
    nDependent=1;
end

% Create locations to hold y values at nodes
G.qg.Nodes.y=nan(G.numnodes,nDependent);
G.qg.Edges.y = cell(numedges(G),1);
nx = G.nx;
for k=1:numedges(G)
    G.qg.Edges.y{k} = nan(nx(k),nDependent);
end