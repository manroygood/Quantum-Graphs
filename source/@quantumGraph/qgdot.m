function z = qgdot(Phi,u1col,u2col)

% Note this does absolutely no checking to determine if two columns are
% compatible with the template Phi. It just plows ahead and returns an error if it doesn't work
u1=copy(Phi); u1.column2graph(u1col);
u2=copy(Phi); u2.column2graph(u2col);
weightVec=u1.Edges.Weight;
z=0;
for k = 1:numedges(u1)
    z = z + weightVec(k)*edgeDot(u1,u2,k);
end

function z = edgeDot(u1,u2,k)

dx = u1.Edges.dx(k);

v1 = u1.Edges.y{k};
v2 = u2.Edges.y{k};

v1Ends= u1.Nodes.y(u1.Edges.EndNodes(k,:));
v2Ends= u2.Nodes.y(u2.Edges.EndNodes(k,:));

z = dx * (dot(v1,v2) + dot(v1Ends,v2Ends)/2);