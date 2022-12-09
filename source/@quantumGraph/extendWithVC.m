function MExtended = extendWithVC(G,M)
% Append the vertex condition matrix to the wide matrix M
VCMat = G.discreteVCMatrix;

assert(size(M,2)==size(VCMat,2),'The input matrix has the wrong number of columns')

MExtended=[M; VCMat];

assert(size(MExtended,1)==size(MExtended,2),'The output matrix must be square')