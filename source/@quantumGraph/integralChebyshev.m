function z = integralChebyshev(G,yColumn)
% Note this does absolutely no checking to determine if two columns are
% compatible with the template G. It just surges ahead and returns an
% error if it doesn't work

if exist('yColumn','var')
    G.column2graph(yColumn);
end

weightVec = G.Edges.Weight;


z = 0;
for k = 1:G.numedges
    y=G.y{k};
    L = G.Edges.L(k);
    z = z + weightVec(k)*clencurt(y,L);
end