function constructMatricesUniform(G)
% Constructs several matrices needed for the finite difference

%% Construct the Laplacian matrix for the quantum graph domain G
% Uses centered second differences in space, and ghost points at junctions.
% The first point of the discretization is at dx(k)/2 and the ghost point
% is at -dx(k)/2;
nEdges=G.numedges;
nNodes=G.numnodes;
[nxVec,nxC,nxTot]=nx(G);
LMat = spalloc(nxTot,nxTot,3*nxTot);
WMat = spalloc(nxTot,nxTot,nxTot);
DMat = spalloc(nxTot,nxTot,2*nxTot+2*nEdges);

dx=G.Edges.dx;
alpha= G.Nodes.robinCoeff;
w = G.Edges.Weight;

% The standard Laplacian away from the at the interior points
% The Weight matrix is just the identity on the interior points
for k=1:nEdges
    % Construct the Laplacian matrix
    n = nxVec(k);
    e = ones(n+2,1);
    A = spdiags([e -2*e e], -1:1, n+2, n+2)/dx(k)^2;
    [leftCol,rightCol,topRow,bottomRow]=getBounds(nxC,k);
    % Since the laplace matrix maps the full interval to the interior, we
    % throw away the top and bottom row
    LMat(topRow:bottomRow,leftCol:rightCol)=A(2:end-1,:);           %#ok<*SPRIX>
    % Construct the weight matrix
    B =speye(n+2);
    WMat(topRow:bottomRow,leftCol:rightCol)=B(2:end-1,:);
    % Construct the 2nd order centered difference matrix for the first
    % derivative matrix (one sided at endpoints)
    D1=spdiags([-e zeros(size(e)) e]/2/dx(k),-1:1,n+2,n+2);
    D1(1,1:3)=[-3 4 -1]/2/dx(k);
    D1(end,end-2:end)=[1 -4 3]/2/dx(k);
    DMat(leftCol:rightCol,leftCol:rightCol)=D1;
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

VCAMat = spalloc(nxTot,nNodes,nNodes);
row = bottomRow;
for j=1:nNodes   % Loop over the nodes
    [fullDegree,inOrOut,connectedEdges] = G.fullDegreeEtc(j);
    for k=1:fullDegree   % Loop over the edges connected to the node
        edge = connectedEdges(k);
        direction = inOrOut(k);
        [ghostPt,interiorPt] = G.getEndPoints(direction,edge);
        row=row+1;
        
        if k ==1    % At first entry of block, enforce either Dirichlet or flux condition & put a one in the right spot of VCAMat
            if G.isDirichlet(j)  % Define Dirichlet Boundary Condition
                LMat(row,ghostPt)=1/2;
                LMat(row,interiorPt)=1/2;
            else                 % Define flux condition
                for branch = 1:fullDegree
                    edge = connectedEdges(branch);
                    direction = inOrOut(branch);
                    [ghostPt,interiorPt] = getEndPoints(G,direction,edge);
                    LMat(row,ghostPt) = alpha(j)/2/fullDegree - w(edge)/dx(edge);
                    LMat(row,interiorPt) = alpha(j)/2/fullDegree + w(edge)/dx(edge);
                    
                end
            end
            VCAMat(row,j)=1;
        else                 % At remaining entries of  block, enforce continuity condition
            LMat(row,ghostPt) = 1;
            LMat(row,interiorPt) = 1;
            edge = connectedEdges(1);
            direction = inOrOut(1);
            [ghostPt,interiorPt] = getEndPoints(G,direction,edge);
            LMat(row,ghostPt) = -1;
            LMat(row,interiorPt) = -1;
        end
    end
end

G.laplacianMatrix = LMat;
G.weightMatrix = WMat;
G.vertexConditionAssignmentMatrix=VCAMat;
G.derivativeMatrix = DMat;

end