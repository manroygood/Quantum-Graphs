function z = qgdotCheb(Phi,u1col,u2col)
% Note this does absolutely no checking to determine if two columns are
% compatible with the template Phi. It just surges ahead and returns an
% error if it doesn't work

% u1 = copy(Phi); u1.column2graph(u1col);
% u2 = copy(Phi); u2.column2graph(u2col);
% weightVec = u1.Edges.Weight;
weightVec = Phi.Edges.Weight;
z = 0;
for k = 1:numedges(Phi)
    z = z + weightVec(k)*edgeDotCheb(Phi,u1col,u2col,k);
end

end 


function z = edgeDotCheb(Phi,v1,v2,k)

l = Phi.Edges.L(k);
f = v1.*v2;
z = clencurt(f,l);  % Uses Clenshaw-Curtis quadrature to integrate 

end

% function z = edgeDotCheb(u1,u2,k)
% 
% l = u1.Edges.L(k);
% 
% v1 = u1.Edges.y{k};
% v2 = u2.Edges.y{k};
% f = v1.*v2;
% 
% z = clencurt(f,l);  % Uses Clenshaw-Curtis quadrature to integrate 
% 
% end