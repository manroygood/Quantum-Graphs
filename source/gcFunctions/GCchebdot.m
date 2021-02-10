function z = GCchebdot(Phi,u1col,u2col)
% Note this does absolutely no checking to determine if two columns are
% compatible with the template Phi. It just plows ahead and returns an
% error if it doesn't work

u1 = copy(Phi); u1.column2graph(u1col);
u2 = copy(Phi); u2.column2graph(u2col);
weightVec = u1.Edges.Weight;
z = 0;
for k = 1:numedges(u1)
    z = z + weightVec(k)*edgeDotCheb(u1,u2,k);
end

end 


function z = edgeDotCheb(u1,u2,k)

n = u1.Edges.nx(k);     % THIS IS UNUSED AT THIS POINT. I HAD CALLED IT IN CLENCURT THEN ADDED 2 TO INCLUDE ENDPOINTS BUT THEN IT DOESN'T MATCH F SO I DON'T KNOW WHAT TO DO ANYMORE
l = u1.Edges.L(k);

v1 = u1.Edges.y{k};     % WHAT IS Y?! WHAT DO *I* DO FOR Y?!
v2 = u2.Edges.y{k};
f = v1.*v2;

z = clencurt(f,l);  % Uses Clenshaw-Curtis quadrature to integrate 

end