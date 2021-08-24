function [f,C] = myFunc(G,type)

nEdges = length(G.L);   % Number of edges
nBCs = 2*nEdges;        % Number of BC conditions
[~,~,n] = G.nx;         % Number of x points

A = G.laplacianMatrix;                      % The second spatial derivative operator
B = G.weightMatrix;                         % The rectangular collocation or weight matrix
C = [B(1:(n-nBCs),:); A((n-nBCs+1):n,:)];   % Weight matrix diagonal with boundary data in bottom rows

if type == 1
    f = @(t,z) A*z;
elseif type == 2
    f = @(t,z) 1i * A*z;
elseif type == 3
    f = @(t,z) A*z + z - z.^2;
else
    f = @(t,z) 1i * (A*z + B*(2*z.^3  + z)); %(( A*z ) + B*((z.*conj(z)).*z));
end

end