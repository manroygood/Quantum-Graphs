function [M,B] = constructLaplacianMatrixUni(G)
% Construct the Laplacian matrix for the quantum graph domain G
% Assumes Kirchoff junction conditions which reduce to Neumann at leaf
% nodes
% Uses centered second differences in space, and ghost points at junctions.
% The first point of the discretization is at dx(k)/2 and the ghost point
% is at -dx(k)/2;
[nxVec,nxC,nxTot]=nx(G);
M = spalloc(nxTot,nxTot,3*nxTot);
dx=G.Edges.dx;

% The standard Laplacian away from the junctions
for k=1:numedges(G)
    n = nxVec(k);
    e = ones(n,1);
    A = spdiags([e -2*e e], -1:1, n, n)/dx(k)^2;
    M(nxC(k)+1:nxC(k+1),nxC(k)+1:nxC(k+1))=A; %#ok<SPRIX>
end

nDirichlet=sum(G.isDirichlet);
nNodes=numnodes(G);

% The Laplacian is modified at the grid points adjacent to the junctions
% where Robin or Kirchhoff conditions hold. Do nothing at Dirichlet nodes
for j=1:nNodes-nDirichlet    % Loop over the nodes
    mat=G.Nodes.ghostMatrix{j};
    if ~isDirichlet(G,j)
        [fullDegree,inOrOut,allEdges]=fullDegreeEtc(G,j);
        for branch = 1:fullDegree   % loop over all edges adjacent to given nodes (rows of matrix)
            rowBranch = allEdges(branch);
            rowDirection = inOrOut(branch);
            row = getRowOrColumn(G,rowDirection,rowBranch);
            dx=G.Edges.dx(rowBranch);
            for neighbor = 1:fullDegree % loop over all neighboring edges, including self (columns of matrix)
                columnBranch = allEdges(neighbor);
                columnDirection = inOrOut(neighbor);
                column= getRowOrColumn(G,columnDirection,columnBranch);
                M(row,column) = M(row,column) + mat(branch,neighbor)/dx^2; %#ok<SPRIX>
            end
        end
    end
end

B = speye(length(M));


% Helper function for finding the rows and columns needed for the
% corrected Laplacian matrix
function rc=getRowOrColumn(G,rowDirection,rowBranch)
[~,nxC,~]=nx(G);
if rowDirection== 1            % If this is an incoming edge
    rc=nxC(rowBranch+1);
elseif rowDirection == -1      % If this is an outgoing edge
    rc=nxC(rowBranch)+1;
end
