function M = quantumGraphLaplacianPML(Phi,PMLparams)
% Construct the Laplacian matrix for the quantum graph domain Phi
% 
% Uses centered second differences in space, and ghost points at junctions.
% The first point of the discretization is at dx(k)/2 and the ghost point
% is at -dx(k)/2;


d=PMLparams.d;
sigma=PMLparams.sigma;
p=PMLparams.p;
gamma=PMLparams.gamma;
[nxVec,nxC,nxTot]=Phi.nx;
M = spalloc(nxTot,nxTot,3*nxTot);
dx=Phi.Edges.dx;

% The standard Laplacian away from the junctions
for k=1:numedges(Phi)
    nx = nxVec(k);
    x = Phi.Edges.x{k};x=x(:);
    L = Phi.Edges.L(k)-d;
    sigma1=@(x)(sigma*(x/d).^p);
    sigmaFunction = @(x) (x>L).*sigma1(x-L);
    v=@(x) (1./(1+exp(1i*gamma)*sigmaFunction(x)));
    
    vOn = v(x);
    vLeft = v(x-dx(k)/2);
    vRight = v(x+dx(k)/2);
    
    v1 = vOn.*vLeft;
    v2 = vOn.*vRight;
    
    A = spdiags([v1 -(v1+v2) v2], -1:1, nx, nx)/dx(k)^2;
    M(nxC(k)+1:nxC(k+1),nxC(k)+1:nxC(k+1))=A;
end

nDirichlet = sum(isDirichlet(Phi));
nNodes=numnodes(Phi);

% The Laplacian is modified at the grid points adjacent to the junctions
% where Robin or Kirchhoff conditions hold. Do nothing at Dirichlet nodes
for j=1:nNodes-nDirichlet    % Loop over the nodes
    mat=Phi.Nodes.ghostMatrix{j};
    if ~isDirichlet(Phi,j)
        [fullDegree,inOrOut,allEdges]=fullDegreeEtc(Phi,j);
        for branch = 1:fullDegree   % loop over all edges adjacent to given nodes (rows of matrix)
            rowBranch = allEdges(branch);
            rowDirection = inOrOut(branch);
            row = getRowOrColumn(Phi,rowDirection,rowBranch);
            dx=Phi.Edges.dx(rowBranch);
            for neighbor = 1:fullDegree % loop over all neighboring edges, including self (columns of matrix)
                columnBranch = allEdges(neighbor);
                columnDirection = inOrOut(neighbor);
                column= getRowOrColumn(Phi,columnDirection,columnBranch);
                M(row,column) = M(row,column) + mat(branch,neighbor)/dx^2; %#ok<SPRIX>
            end
        end
    end
end

% Helper function for finding the rows and columns needed for the
% corrected Laplacian matrix
function rc=getRowOrColumn(G,rowDirection,rowBranch)
[~,nxC,~]=G.nx;
if rowDirection== 1            % If this is an incoming edge
    rc=nxC(rowBranch+1);
elseif rowDirection == -1      % If this is an outgoing edge
    rc=nxC(rowBranch)+1;
end