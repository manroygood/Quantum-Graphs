function x=distributePlotCoords(G,xStart,xFinal,edge)
n=G.nx(edge);

if G.isUniform    
    xx = ( (1:n) - 1/2 )'/n; 
    xx= [0; xx; 1];
elseif G.isChebyshev
    xx = chebptsSecondKind(n);
end
x = xStart + (xFinal-xStart)*xx;