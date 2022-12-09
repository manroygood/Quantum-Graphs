function M = nonhomogeneousVCMatrixPadded(G)
[~,~,nxTot]=G.nx;
M = [sparse(nxTot-2*G.numedges,G.numnodes); G.nonhomogeneousVCMatrix];
