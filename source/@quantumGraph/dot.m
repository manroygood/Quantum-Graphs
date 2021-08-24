function z = dot(G,u1col,u2col)

if G.isUniform
    z = dotUniform(G,u1col,u2col);
elseif G.isChebyshev
    z = dotChebyshev(G,u1col,u2col);
else
   error('quantumGraph:dotWrongDiscretization',...
         'Discretization must be uniform or Chebyshev')
end