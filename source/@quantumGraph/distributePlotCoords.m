function x=distributePlotCoords(G,xStart,xFinal,edge)
n=G.nx(edge);

if isinf(G.L(edge))
    L = G.stretch(edge);
    if G.isUniform
        s = ( (1:n) - 1/2 )'/n;
        s= [0; s; 1];
        xx = sinh(L*s)/sinh(L);
    elseif G.isChebyshev
        s = chebptsSecondKind(n);
        xx = sinh(L*(1-sqrt(1-s)))/sinh(L);
    end
else
    if G.isUniform
        xx = ( (1:n) - 1/2 )'/n;
        xx= [0; xx; 1];
    elseif G.isChebyshev
        xx = chebptsSecondKind(n);
    end
end
x = xStart + (xFinal-xStart)*xx;