function addCoordinates(G,nxVec)

if strcmp(G.discretization,'Uniform')
    G.addCoordinatesUniform(nxVec);
elseif strcmp(G.discretization,'Chebyshev')
    G.addCoordinatesChebyshev(nxVec);
else
    error('quantumGraph:addCoordinates',...
        'Something is weird, this error should have been caught already!')
end