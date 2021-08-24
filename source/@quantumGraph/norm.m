function z = norm(G,varargin)

vec = varargin{1};
if G.isUniform
    z = normUniform(G,vec);
elseif G.isChebyshev
    z = normChebyshev(G,vec);
else
   error('quantumGraph:dotWrongDiscretization',...
         'Discretization must be uniform or Chebyshev')
end