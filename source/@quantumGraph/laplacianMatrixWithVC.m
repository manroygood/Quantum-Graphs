function M = laplacianMatrixWithVC(G)
M = G.wideLaplacianMatrix;
if G.hasPotential
    M = M - G.potentialMatrix;
end
M = G.extendWithVC(M);