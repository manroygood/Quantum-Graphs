function constructMatrices(G)

if strcmp(G.discretization,'Uniform')
    G.constructMatricesUniform;
elseif strcmp(G.discretization,'Chebyshev')
    G.constructMatricesChebyshev;
else
    error('quantumGraph:constructionDiscretization',...
        'Something is weird, this error should have been caught already!')
end