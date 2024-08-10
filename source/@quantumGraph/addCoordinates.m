function addCoordinates(G,opts)

if strcmp(G.discretization,'Uniform')
    G.addCoordinatesUniform(opts);
elseif strcmp(G.discretization,'Chebyshev')
    G.addCoordinatesChebyshev(opts);
else
    error('quantumGraph:addCoordinates',...
        'Something is weird, this error should have been caught already!')
end