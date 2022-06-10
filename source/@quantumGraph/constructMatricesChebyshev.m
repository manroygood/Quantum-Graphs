function constructMatricesChebyshev(G)
% Constructs several matrices needed for the finite difference 

%% Construct the Laplacian matrix for the quantum graph domain G
% Produces the Laplacian matrix A with encoded boundary conditions and
% projection matrix B that would be used for the eigenvalue problem
% A*x = lambda.B*x

nEdges = G.numedges;        % Number of edges
nNodes = G.numnodes;        % Number of nodes
[n,nxC,nxTot] = G.nx;       % A useful vector giving positions of final disc point of each edge
L = G.L;                    % Vector of edge lengths
D1matrix = zeros(nxTot,nxTot);
D2matrix = zeros(nxTot-2*nEdges, nxTot);   % D2matrix will contain the blocked D2 matricies and no BCs
B = zeros(nxTot,nxTot);                    % Initializes projection matrix

for i=1:nEdges       % Loops over each edge
    clear D1 D2
    
    N = n(i)+2;   % Number of disc. pts. on e_i
    M = n(i);     % Number of rows needed
    
    D1 = chebyshevDeriv(N,L(i));        % D1 matrix with chebyshev disc points of the second kind
    D2 = diffMatrixOrderP(M,N,2,L(i));  % D2 has already been projected onto internal disc points
    Project = rectdiff_bary(M,N);       % Projection matrix on edge_i
    
    % Builds D2 blocks for whole Quantum Graph
    if i==1
        x = 0;
    else
        x = x + n(i-1);         % Positions us so that we move past the previously built portion of the D2 part of the matrix
    end
    
    D1matrix( (nxC(i)+1):nxC(i+1) , (nxC(i)+1):nxC(i+1)) = D1;     % Creates square D1 matrix
    D2matrix( (x+1):(x+M) , (nxC(i)+1):nxC(i+1) ) = D2;
    B( (x+1):(x+M) , (nxC(i)+1):nxC(i+1) ) = Project;
 
end

%% Populate the boundary condition rows
% The last (2*numedges) rows of the Laplacian matrix implement the boundary
% conditions. Note that the sum of the degrees of all nodes = (2*numedges).
% Therefore first loop over the nodes and then loop over the connected
% edges. The boundary conditions at each vertex are implemented in a block of 
% "fullDegree" rows. The first row of a block encodes the flux condition or
% the Dirichlet condition. The remaining rows of the block enforce
% continuity.

% Create the Vertex Condition Assignment Matrix VCAMat which maps the nonhomogeneous data
% defined at the vertices to the correct row

VCAMat = zeros(nxTot,nNodes);
BC = zeros(2*nEdges,nxTot);                % Initializes space for Boundary Conditions

row = 0;
for j=1:nNodes     % Loop over the nodes
    [fullDegree,~,~] = G.fullDegreeEtc(j);
    
    for k=1:fullDegree   % Loop over the edges connected to the node
        row = row + 1;

        if k == 1   % At first entry of block, enforce either Dirichlet or flux condition & put a one in the right spot of VCAMat
            BC(row,:) = robinCondition(G,j,D1matrix);
            VCAMat(nxTot-2*nEdges+row,j) = 1;
        else        % At remaining entries of block enforce continuity condition
            e1 = G.ek(j,1);
            e2 = G.ek(j,k);
            BC(row,:) = e1 - e2;
        end
        
    end
end

LMat = [D2matrix; BC];
C = B;
C(nxTot-2*nEdges+1:end,:) = BC;

G.derivativeMatrix = -D1matrix;
G.laplacianMatrix = LMat;
G.weightMatrix = B;
G.weightMatrixWithBCs = C;
G.vertexConditionAssignmentMatrix=VCAMat;



end


