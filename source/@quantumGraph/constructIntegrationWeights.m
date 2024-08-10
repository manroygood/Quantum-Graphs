function constructIntegrationWeights(G)

if strcmp(G.discretization,'Uniform')
    G.constructIntegrationWeightsUniform;
elseif strcmp(G.discretization,'Chebyshev')
    G.constructIntegrationWeightsChebyshev;
else
    error('quantumGraph:constructionIntegrationWeights',...
        'Something is weird, this error should have been caught already!')
end