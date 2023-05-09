function addInteriorGrid(G)

assert(G.hasDiscretization',...
    'addInteriorGrid:noDiscretization',...
    'There must be a discretization specified to add interior grid')

assert(~G.hasEdgeField('xInterior'),...
    'addInteriorGrid:xInteriorDefined','Interior grid already defined')

if G.hasDiscretization('Uniform')
    G.addInteriorGridUniform
elseif G.hasDiscretization('Chebyshev')
    G.addInteriorGridChebyshev
end