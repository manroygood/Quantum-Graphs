function M = laplacianMatrixWithZeros(G)
M = G.extendWithZeros(G.wideLaplacianMatrix);