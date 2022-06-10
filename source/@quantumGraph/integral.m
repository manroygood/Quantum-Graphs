function z = integral(G,yColumn)

if G.isUniform
    if exist('yColumn','var')
        z = G.integralUniform(yColumn);
    else
        z=G.integralUniform;
    end
elseif G.isChebyshev
     if exist('yColumn','var')
        z = G.integralChebyshev(yColumn);
    else
        z=G.integralChebyshev;
    end
else
    error('quantumGraph:integralWrongDiscretization',...
        'Discretization must be uniform or Chebyshev')
end