function spy(G)
% Show the structure of the nonzero entries of the Laplacian matrix for the
% discretized quantum graph G
discretization = G.discretization;
spy(G.wideLaplacianMatrix);
title(sprintf('Discrete Laplacian Matrix--%s discretization',discretization))
figure;
spy(G.interpolationMatrix);
title(sprintf('Interpolation Matrix--%s discretization',discretization))
figure
spy(G.discreteVCMatrix)
title(sprintf('Vertex condition matrix--%s discretization',discretization))