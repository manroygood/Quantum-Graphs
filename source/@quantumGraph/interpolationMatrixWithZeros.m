function M = interpolationMatrixWithZeros(G)
M = G.extendWithZeros(G.interpolationMatrix);