function M = laplacianMatrixWithZeros(G)
M = G.wideLaplacianMatrix;
if G.hasPotential
    M = M - G.interpolationMatrix*diag(G.potential);
end
M = G.extendWithZeros(M);