function MExtended = extendWithZeros(G,M)
% Append a matrix of zeros to the wide matrix M
VCMat = G.discreteVCMatrix;

assert(size(M,2)==size(VCMat,2),'The input matrix has the wrong number of columns')

MExtended=[M; zeros(2*G.numedges,size(M,2))];

assert(size(MExtended,1)==size(MExtended,2),'The output matrix must be square')