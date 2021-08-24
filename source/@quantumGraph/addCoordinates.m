function addCoordinates(G,nxVec)

if strcmp(G.discretization,'Uniform')
    G.addUniformCoordinates(nxVec);
elseif strcmp(G.discretization,'Chebyshev')
    G.addChebyshevCoordinates(nxVec);
else
    error('quantumGraph:addCoordinates',...
        'Something is weird, this error should have been caught already!')
end