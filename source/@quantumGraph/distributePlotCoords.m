function x=distributePlotCoords(Phi,xStart,xFinal,edge)
n=Phi.nx(edge);

if Phi.isUniform    
    xx = ( (1:n) - 1/2 )'/n; 
elseif Phi.isChebyshev
    xx = (cos(pi*(n-1:-1:1)'/n)+1)/2;
end
x = xStart + (xFinal-xStart)*xx;