function constructMatricesUniform(G)
% Constructs several matrices needed for the finite difference

%% Construct the Laplacian matrix for the quantum graph domain G
% Uses centered second differences in space, and ghost points at junctions.
% The first point of the discretization is at dx/2 and the ghost point is at -dx/2;
nEdges=G.numedges;
nNodes=G.numnodes;
[nxVec,nxC,nxTot]=G.nx;
nxInt = nxTot-2*nEdges;
LaplaceMat = spalloc(nxInt,nxTot,3*nxTot);           % This will be the wide Laplacian
InterpoMat = spalloc(nxInt,nxTot,nxTot);
DerivMat = spalloc(nxTot,nxTot,2*nxTot+2*nEdges);

dxVec=G.Edges.integrationWeight;
alpha= G.robinCoeff;
w = G.Edges.Weight;

% The standard Laplacian away from the at the interior points
% The Weight matrix is just the identity on the interior points
for k=1:nEdges
    n = nxVec(k);
    % Construct the weight matrix
    B =speye(n+2);
    [leftCol,rightCol,topRow,bottomRow]=getBounds(nxC,k);
    InterpoMat(topRow:bottomRow,leftCol:rightCol)=B(2:end-1,:);
    if G.isCompact(k)
        % Construct the Laplacian matrix
        dx = dxVec{k};
        e = ones(n+2,1);
        A = spdiags([e -2*e e], -1:1, n+2, n+2)/dx^2;
        % Since the Laplace matrix maps the full interval to the interior, we
        % throw away the top and bottom row
        LaplaceMat(topRow:bottomRow,leftCol:rightCol)=A(2:end-1,:);           %#ok<*SPRIX>

        % Construct the 2nd order centered difference matrix for the first
        % derivative matrix (one sided at endpoints)
        D1=spdiags([-e zeros(size(e)) e]/2/dx,-1:1,n+2,n+2);
        D1(1,1:3)=[-3 4 -1]/2/dx;
        D1(end,end-2:end)=[1 -4 3]/2/dx;
        DerivMat(leftCol:rightCol,leftCol:rightCol)=D1;
    else
        stretch=G.stretch(k);
        ds = 1/n;
        ss = stretch*linspace(-ds/2,1+ds/2,n+2)';
        g = sech(ss)/stretch;
        gprime = -sech(ss).*tanh(ss);
        w2a = g.^2;
        w2b = g.*gprime;
        diff1 = spdiags((-1:1)/2/ds,-1:1,n+2,n+2);
        diff1(1,1:3)=[-3 4 -1]/2/ds;
        diff1(end,end-2:end)=[1 -4 3]/2/ds;
        diff2 = spdiags(([1 -2 1])/ds^2,-1:1,n+2,n+2);
        DerivMat(leftCol:rightCol,leftCol:rightCol) = sparse(diag(g))*diff1;
        D2 = sparse(diag(w2a))*diff2 + sparse(diag(w2b))*diff1;
        LaplaceMat(topRow:bottomRow,leftCol:rightCol) = D2(2:end-1,:);
    end
end

G.wideLaplacianMatrix = LaplaceMat;
G.interpolationMatrix = InterpoMat;
G.derivativeMatrix = DerivMat;

%% Populate the vertex condition matrices

% The  (2*numedges) rows of the G.discreteVCMatrix implement the vertex conditions.
% We first loop over the nodes and then loop over the connected
% edges. The boundary conditions at each vertex are implemented in a block of
% "fullDegree" rows. The first row of a block encodes the flux condition or
% the Dirichlet condition. The remaining rows of the block enforce
% continuity.

% Create the nonhomogeneousVCMat which maps the nonhomogeneous data
% defined at the vertices to the correct row

discreteVCMat = spalloc(2*nEdges,nxTot,3*nEdges);
nonhomogeneousVCMat = spalloc(nxTot,nNodes,nNodes);
row = 0;
for j=1:nNodes   % Loop over the nodes
    [fullDegree,inOrOut,connectedEdges] = G.fullDegreeEtc(j);
    for k=1:fullDegree   % Loop over the edges connected to the node
        edge = connectedEdges(k);
        direction = inOrOut(k);
        [ghostPt,interiorPt] = G.getEndPoints(direction,edge);
        row=row+1;
        if k ==1    % At first entry of block, enforce either Dirichlet or flux condition
            % Also put a one in the right spot of VCAMat
            if G.isDirichlet(j)  % Define Dirichlet Boundary Condition
                discreteVCMat(row,ghostPt)=1/2;
                discreteVCMat(row,interiorPt)=1/2;
            else                 % Define flux condition
                for branch = 1:fullDegree
                    edge = connectedEdges(branch);
                    if G.isCompact(edge)
                        dx = dxVec{edge};
                    else
                        stretch=G.stretch(edge);
                        n = nxVec(edge);
                        ds = 1/n;
                        dx =stretch*ds;
                    end
                    direction = inOrOut(branch);
                    [ghostPt,interiorPt] = getEndPoints(G,direction,edge);
                    discreteVCMat(row,ghostPt) = alpha(j)/2/fullDegree - w(edge)/dx;
                    discreteVCMat(row,interiorPt) = alpha(j)/2/fullDegree + w(edge)/dx;

                end
            end
            nonhomogeneousVCMat(bottomRow+row,j)=1;
        else                 % At remaining entries of  block, enforce continuity condition
            discreteVCMat(row,ghostPt) = 1;
            discreteVCMat(row,interiorPt) = 1;
            edge = connectedEdges(1);
            direction = inOrOut(1);
            [ghostPt,interiorPt] = getEndPoints(G,direction,edge);
            discreteVCMat(row,ghostPt) = -1;
            discreteVCMat(row,interiorPt) = -1;
        end
    end
end

G.nonhomogeneousVCMatrix=nonhomogeneousVCMat;
G.discreteVCMatrix = discreteVCMat;


end