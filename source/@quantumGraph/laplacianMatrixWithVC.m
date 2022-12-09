function M = laplacianMatrixWithVC(G)
M = G.extendWithVC(G.wideLaplacianMatrix);