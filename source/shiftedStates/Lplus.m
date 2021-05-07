function L = Lplus(Phi)
u0=Phi.graph2column;
potential=6*u0.^2;
%potential=flipud(potential);
n=length(potential);
L = -Phi.laplacianMatrix +speye(length(u0)) - spdiags(potential,0,n,n);