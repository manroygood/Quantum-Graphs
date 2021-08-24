function z = dotUniform(G,u1col,u2col)

% Note this does absolutely no checking to determine if two columns are
% compatible with the template G. It just plows ahead and returns an error if it doesn't work
u1=copy(G); u1.column2graph(u1col);
u2=copy(G); u2.column2graph(u2col);
weightVec=u1.Edges.Weight;
z=0;
for k = 1:numedges(u1)
    z = z + weightVec(k)*edgeDot(u1,u2,k);
end

% Note that because x-values on the edges of the graph are offset by dx/2
% each lies at the midpoint of a domain of size dx and using the midpoint
% rule to compute dot products is second order accurate (i.e., we don't need
% to modify the rule near the endpoints, as for the trapezoidal rule)
function z = edgeDot(u1,u2,k)
dx = u1.Edges.dx(k);
v1 = u1.Edges.y{k};
v2 = u2.Edges.y{k};

z = dx * dot(v1,v2) ;