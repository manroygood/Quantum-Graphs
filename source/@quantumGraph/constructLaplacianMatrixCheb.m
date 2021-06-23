function [A,B] = constructLaplacianMatrixCheb(G)
% Produces the Laplacian matrix A with encoded boundary conditions and
% projection matrix B that would be used for the eigenvalue problem
% A*x = lambda.B*x

medges = G.numedges;        % Number of edges
mnodes = G.numnodes;        % Number of nodes
mleaf = G.countLeaf;        % Number of leaf nodes
minternal = mnodes-mleaf;   % Number of internal nodes
[~,nxC,~] = G.nx;           % A useful vector giving positions of final disc point of each edge
L = G.L;                    % Vector of edge lengths
n = G.Edges.nx + 2*ones(size(G.Edges.nx));         % Vector of disc. points
alpha = G.robinCoeff;       % Conditions at the nodes
sizeintnodes = 0;           % Tracks number of internal nodes
bc = 1;                     % Keeps track of where we are in the BC portion of the matrix
kirchoffbc = 1;             % Keeps track of where the Kirchoff Conditions are being placed in BC matrix
nx = 0;                     % Index of first disc pt of the solution on a given edge
I = eye(sum(n));            % A handy identity matrix
D1matrix = zeros(sum(n),sum(n),medges);
D2matrix = zeros(sum(n)-2*medges, sum(n));      % D2matrix will contain the blocked D2 matricies and no BCs
BC = zeros(2*medges,sum(n));                    % Initializing space for Boundary Conditions
B = zeros(sum(n),sum(n));                       % Initializes projection matrix
internalnodes = zeros(minternal,1);             % Initializing vector to store list of internal nodes

for i=1:medges       % Loops over each edge
    clear D1 D2
    
    N = n(i);     % Number of disc. pts. on e_i
    M = N-2;      % Number of rows needed
    
    D1 = chebyshevDeriv(N,L(i));        % D1 matrix with chebyshev disc points of the second kind
    D2 = diffMatrixOrderP(M,N,2,L(i));  % D2 has already been projected onto internal disc points
    Project = rectdiff_bary(M,N);       % Projection matrix on edge_i
    
    % Builds D2 blocks for whole Quantum Graph
    if i==1
        x = 0;
        y = 0;
    else
        x = x + n(i-1)-2;         % Positions us so that we move past the previously built portion of the D2 part of the matrix
        y = y + n(i-1);
    end
    
    D2matrix( (x+1):(x+M) , (y+1):(y+N) ) = D2;
    B( (x+1):(x+M) , (y+1):(y+N) ) = Project;
 
 
    % Boundary Conditions
    [node1,node2] = G.edgeNodes(i);                   % Nodes that are adjacent to e_i
    nx = nx + N;                                        % Position of ui_1
    D1matrix( (nx+1-N):nx , (nx+1-N):nx , i) = D1;      % Creates D1 matrix for edge_i leaving zeros elsewhere
    
    if G.isLeaf(node1)          % If node1 is a Leaf...
        if ismember(i,G.incoming(node1))        % When orientation is node2 -> node1
            if isnan(alpha(node1))              % If Robin Condition is NAN then we have Dirichlet BC's
                BC(bc,:) = I(nxC(i+1),:);       % Picks the last disc point on edge_i because it's incoming
            else
                BC(bc,:) = ( I(nxC(i+1),:)*(-1)*D1matrix(:,:,i) ) + alpha(node1)*I(nxC(i+1),:);
            end
        else                                    % When orientation is node1 -> node2
            if isnan(alpha(node1))              % If Robin Condition is NAN then we have Dirichlet BC's
                BC(bc,:) = I(nxC(i)+1,:);       % Picks the first disc point on edge_i because it's outgoing
            else
                BC(bc,:) = ( I(nxC(i)+1,:)*(-1)*D1matrix(:,:,i) ) + alpha(node1)*I(nxC(i)+1,:);
            end
        end
        bc = bc + 1;
    else                        % If node1 is an internal node...
        if not(ismember(node1,internalnodes))       % add it to the list of internal nodes if it isn't there yet
            sizeintnodes = sizeintnodes + 1;        % Track how many internal nodes we have so far
            internalnodes(sizeintnodes) = node1;
        end
    end
    
    if G.isLeaf(node2)          % If node2 is a Leaf...
        if ismember(i,G.incoming(node2))        % When orientation is node1 -> node2
            if isnan(alpha(node2))              % If Robin Condition is NAN then we have Dirichlet BC's
                BC(bc,:) = I(nxC(i+1),:);       % Picks the last disc point on edge_i because it's incoming
            else
                BC(bc,:) = ( I(nxC(i+1),:)*D1matrix(:,:,i) ) + alpha(node2)*I(nxC(i+1),:);
            end
        else                                    % When orientations is node2 -> node1
            if isnan(alpha(node2))              % If Robin Condition is NAN then we have Dirichlet BC's
                BC(bc,:) = I(nxC(i)+1,:);       % Picks the first disc point on edge_i because it's outgoing
            else
                BC(bc,:) = ( I(nxC(i)+1,:)*D1matrix(:,:,i) ) + alpha(node2)*I(nxC(i)+1,:);
            end
        end
        bc = bc + 1;
    else                        % If node2 is an Internal Node...
        if not(ismember(node2,internalnodes))       % add it to the list of internal nodes if it isn't there yet
            sizeintnodes = sizeintnodes + 1;        % Track how many internal nodes we have so far
            internalnodes(sizeintnodes) = node2;
        end
    end
    
end


% Internal Node Conditions
for i=1:sizeintnodes          % Takes any internal nodes of graph G and applies Kirchoff Conditions
    node = internalnodes(i);                        % The internal node in question
    incoming = transpose(G.incoming(node));         % The incoming edge(s) to the node
    outgoing = transpose(G.outgoing(node));         % The outgoing edge(s) to the node
    adjacentEdges = unique([incoming outgoing]);    
    
    % Selects correct orientation
    if ismember(adjacentEdges(1),incoming)      % If incoming is first...
        e1 = I(nxC(adjacentEdges(1)+1),:);          % pick e1 so it gives us the last disc point on the edge
        c = 1;                                      % and add to the Kirchoff condition
    else                                        % If outgoing is first...
        e1 = I(nxC(adjacentEdges(1))+1 , :);        % pick e1 so it gives us the first disc point on the edge
        c = -1;                                     % and subtract it from the Kirchoff condition
    end
    
    kirchoff = c*e1*(-1)*D1matrix(:,:,adjacentEdges(1));
    
    if ismember(adjacentEdges(1),incoming) && ismember(adjacentEdges(1),outgoing)          % Checks for loop
        e2 = I(nxC(adjacentEdges(1))+1,:);          % e2 picks up the first disc point on the edge
        BC(bc,:) = e1 - e2;                         % Continuity Condition for a loop
        bc = bc + 1;
        kirchoff = kirchoff - e2*(-1)*D1matrix(:,:,adjacentEdges(1));
    end
    
    for j=2:length(adjacentEdges)                   % Finds additional Continuity and Kirchoff Conditions
        
        if ismember(adjacentEdges(j),incoming)      % If the next adjacent edge is incoming...
            e2 = I(nxC(adjacentEdges(j)+1) , :);        % pick the last disc point on that edge..
            BC(bc,:) = e1 - e2;                         % and give the continuity condition...
            bc = bc + 1;
            kirchoff = kirchoff + e2*(-1)*D1matrix(:,:,adjacentEdges(j));     % and the Kirchoff Condition
        end
        
        if ismember(adjacentEdges(j),outgoing)      % If the next adjacent edge is outgoing...
            e2 = I(nxC(adjacentEdges(j))+1,:);          % pick the first disc point on that edge...
            BC(bc,:) = e1 - e2;                         % and give the continuity condition...
            bc = bc + 1;
            kirchoff = kirchoff - e2*(-1)*D1matrix(:,:,adjacentEdges(j));    % and the Kirchoff Condition
        end
    end
    
    BC(2*medges - minternal + kirchoffbc,:) = kirchoff - alpha(node)*e1; % Final Kirchoff Condition: sum u_j' + alpha
    kirchoffbc = kirchoffbc + 1;
    
end

A = [D2matrix; BC];

end

