function yPrime = derivative(G,yColumn)

if ~exist("yColumn","var")
    yColumn=G.graph2column;
end

yPrime = G.derivativeMatrix*yColumn;