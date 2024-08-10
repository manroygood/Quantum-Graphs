function M = laplacianMatrixWithZeros(G)
M = G.wideLaplacianMatrix;
if G.hasPotential
    M = M - G.potentialMatrix;
end
M = G.extendWithZeros(M);