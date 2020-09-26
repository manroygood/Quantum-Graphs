function addDependentCoords(G,nDep)

if ~exist('nDep','var')
    nDep=1;
end

% Create locations to hold y values at nodes
G.qg.Nodes.y=nan(G.numnodes,nDep);
G.qg.Edges.y = cell(numedges(G),1);
nx = G.nx;
for k=1:numedges(G)
    G.qg.Edges.y{k} = nan(nx(k),nDep);
end