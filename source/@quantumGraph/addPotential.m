function V=addPotential(G,varargin)

if nargin==2
    V = varargin{1};
    if iscell(V)
        assert(length(V)==G.numedges,'If V is a cell array, its length must equal the number of edges in G.')
        V=G.applyFunctionsToAllEdges(V);
    elseif isa(V,"function_handle")
        assert(nargin(V)==2,'Is V is a function, it needs two arguments.')
        V=G.applyGraphicalFunction(V);
    end
elseif nargin==3
    functionArray=varargin{1};
    edges=varargin{2};
    V=applyFunctionsToSelectedEdges(G,functionArray,edges,'zero');
end

assert(length(V)==size(G.wideLaplacianMatrix,2),...
    'If V is a vector its length must equal the total number of unknowns in the discretization.');

G.potential = V;