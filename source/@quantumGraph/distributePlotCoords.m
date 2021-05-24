function x=distributePlotCoords(Phi,xStart,xFinal,edge)
n=Phi.Edges.nx(edge);

if Phi.isUniform
    xx = ( (1:n) - 1/2 )'/n; % Note that this works in both the cases of dirichlet or robin/kirchhoff bc's.
elseif Phi.isChebyshev
    chebpts = chebptsSecondKind(n);
    xx = chebpts(2:end-1);
end
x = xStart + (xFinal-xStart)*xx;