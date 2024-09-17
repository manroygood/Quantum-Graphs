function M = laplacianMatrixWithVC(G)
M = G.wideLaplacianMatrix;
if G.hasPotential
    M = M -  G.interpolationMatrix*diag(G.potential);
end
M = G.extendWithVC(M);