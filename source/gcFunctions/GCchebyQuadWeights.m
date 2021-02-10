function Q = GCchebyQuadWeights(G)
% Uses Clenshaw-Curtis quadrature to define the necessary weights for an 
% inner product between u and v on a graph G. It discretizes edges using
% Chebyshev points and produces a diagnol matrix of weights so that uQv'
% is equivalent to int uv dx where dx is not necessarily uniform

m = numedges(G);    % Number of edges in graph G
N = G.Edges.nx;     % Vector with the number of discretization points on each edge
l = G.Edges.L;      % Vector with the length of each edge
a = 0;              % Tracks location in matrix wrt which edge it is on
Q = zeros(sum(G.Edges.nx)); % Initialize matrix of weights

for i = 1:m
    n = N(i) - 1;                           % Number of disc pts on ith edge minus 1 so we can start at 0
    length = l(i);                          % Length of the ith edge
    theta = pi*(0:n)'/n;                    % 
    x = length*(cos(pi*(0:n)/n)+1)/2;       % Chebyshev points 2nd kind that have been propperly scaled
    
    w = zeros(1,n+1);       % Initiallizing weights
    ii = 2:n;               % 
    v = ones(n-1,1);        % 
    
    if mod(n,2)==0
        w(1) = 1/(n^2 - 1);
        w(n+1) = w(1);
        for k = 1:n/2-1
            v = v - 2*cos(2*k*theta(ii)) / (4*k^2 - 1);
        end
        v = v - cos(n*k*theta(ii)) / (4*k^2 - 1);
    else
        w(1) = 1/n^2;
        w(n+1) = w(1);
        for k = 1:(n-1)/2
            v = v - 2*cos(2*k*theta(ii)) / (4*k^2 - 1);
        end
    end
    
    w(ii) = 2*v/n;
    
    for j = 1:N(i)
        Q(j+a,j+a) = w(j);
    end
    
    a = a + N(i);
    
end

Q = Q./2;

end