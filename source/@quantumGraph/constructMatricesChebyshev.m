function constructMatricesChebyshev(G)
% Constructs several matrices needed for the finite difference

%% Construct the Laplacian matrix for the quantum graph domain G
% Produces the Laplacian matrix
% interpolation matrix B
nEdges = G.numedges;        % Number of edges
nNodes = G.numnodes;        % Number of nodes
[nxVec,nxC,nxTot] = G.nx;       % A useful vector giving positions of final disc point of each edge
nxInt = nxTot-2*nEdges;
LaplaceMat = zeros(nxInt, nxTot);   % D2matrix will contain the blocked D2 matricies and no BCs
InterpoMat = zeros(nxInt,nxTot);                    % Initializes projection matrix
DerivMat = zeros(nxTot,nxTot);             % Used to define Robin-Kirchhoff Boundary Conditions

L = G.L;                    % Vector of edge lengths

for k=1:nEdges        % Loops over each edge

    M = nxVec(k);     % Number of rows needed
    N = nxVec(k)+2;   % Number of discrete points on e_i
    Project = rectdiff_bary(M,N);       % Projection matrix on edge_i
    [leftCol,rightCol,topRow,bottomRow]=getBounds(nxC,k);


    if G.isCompact(k)


        D = chebyshevDeriv(N,L(k));        % D1 matrix with Chebyshev discretization points of the second kind
        D2 = diffMatrixOrderP(M,N,2,L(k));  % D2 has already been projected onto internal disc points

    else
        stretch=G.stretch(k);
        % The interior grid sInt
        sInt = (1 - cos( ((2* (0:(M-1))'+1) * pi)/(2*M) ))/2;

        diff1 = diffMatrixOrderP(M,N,1,1);
        diff2 = diffMatrixOrderP(M,N,2,1);

        [g,gprime]=getStretchedDerivWeightsCheb(sInt,stretch);

        D2a = diag(g.^2)*diff2;
        D2b = diag(g.*gprime)*diff1;
        D2 = D2a + D2b;

        % The extended grid sExt 
        %sExt = (1 - cos( pi*(0:(M+1))'/(M+1) ))/2;
        sExt = chebptsSecondKind(M);
        g=getStretchedDerivWeightsCheb(sExt,stretch);
        D = diag(g)*chebyshevDeriv(N,1);

    end


    DerivMat(leftCol:rightCol, leftCol:rightCol) = D;     % Creates square D1 matrix
    LaplaceMat(topRow:bottomRow, leftCol:rightCol) = D2;
    InterpoMat(topRow:bottomRow, leftCol:rightCol) = Project;

end

G.derivativeMatrix = DerivMat;
G.wideLaplacianMatrix = LaplaceMat;
G.interpolationMatrix = InterpoMat;

%% Populate the vertex condition matrices
% The last (2*numedges) rows of the Laplacian matrix implement the boundary
% conditions. Note that the sum of the degrees of all nodes = (2*numedges).
% Therefore first loop over the nodes and then loop over the connected
% edges. The boundary conditions at each vertex are implemented in a block of
% "fullDegree" rows. The first row of a block encodes the flux condition or
% the Dirichlet condition. The remaining rows of the block enforce
% continuity.

% Create:
%  * The nonhomogeneous VC matrix which maps the nonhomogeneous data defined at a vertex to the correct row
%  * discreteVCMat--discretizes the vertex conditions

nonhomogeneousVCMat = zeros(nxTot,nNodes);
discreteVCMat = zeros(2*nEdges,nxTot);                % Initializes space for vertex Conditions

row = 0;
for j=1:nNodes     % Loop over the nodes
    [fullDegree,~,~] = G.fullDegreeEtc(j);

    for k=1:fullDegree   % Loop over the edges connected to the node
        row = row + 1;

        if k == 1   % At first entry of block, enforce either Dirichlet or flux condition & put a one in the right spot of VCAMat
            discreteVCMat(row,:) = G.robinCondition(j,DerivMat);
            nonhomogeneousVCMat(nxInt+row,j) = 1;
        else        % At remaining entries of block enforce continuity condition
            e1 = G.ek(j,1);
            e2 = G.ek(j,k);
            discreteVCMat(row,:) = e1 - e2;
        end

    end
end

G.discreteVCMatrix =  discreteVCMat;
G.nonhomogeneousVCMatrix=nonhomogeneousVCMat;

end