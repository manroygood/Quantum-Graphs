classdef quantumGraph < matlab.mixin.Copyable
    % Declaring this using matlab.mixin.copybable allows us to copy graph objects,
    % i.e. if g is a graph then the command 'g1=copy(g)' will create a new object
    % g1 that duplicates all of the values of g, rather than simply being a
    % second name for g
    properties (Access = private)
        qg      % the main quantum graph, a digraph
    end
    properties (SetAccess = immutable, GetAccess = public)
        discretization  ;
    end    properties (SetAccess = private, GetAccess = public)
        wideLaplacianMatrix;        % the matrix L_int from text (dimension N_int x N_ext)
        interpolationMatrix;        % the matrix P_int from text (dimension N_int x N_ext)
        discreteVCMatrix;           % the matrix M_VC (dimension 2*numedges x N_ext)
        nonhomogeneousVCMatrix;     % The matrix M_NH used for assigning nonhomogeneous VC terms to the right row, dimension N_ext x 2 numedges
        derivativeMatrix;           % a square derivative matrix. Used for computing energy and momentum, dimension N_ext x N_ext
        potential;            % The vector containing the edgewise potential
    end
    methods
        function G=quantumGraph(source,target,LVec,opts)
            % Three required arguments, the rest optional
            % Constructs a quantum graph data structure
            % 6/23/2021 replaced input parser with argument block
            % 7/1/2021 made ghost points actual data points
            % 11/16/2022 made laplacian matrix and interpolation wide
            %            rectangles, to be supplemented by vertex
            %            conditions or zeros

            arguments
                source double {mustBeVector,mustBePositive,mustBeFinite}
                target double {mustBeVector,mustBePositive,mustBeFinite}
                LVec   double {mustBeVector,mustBePositive}
                opts.RobinCoeff double {mustBeVector} = 0;
                opts.Weight double {mustBeVector,mustBePositive} = 1;
                opts.Discretization char {mustBeMember(opts.Discretization,{'None','Uniform','Chebyshev'})} = 'Uniform';
                opts.nxVec double {mustBeVector,mustBePositive,mustBeFinite} = 20;
                opts.plotCoordinateFcn function_handle
                opts.stretch double {mustBeVector,mustBeNonnegative,mustBeFinite}
                opts.potential cell
            end

            %%%% Here we do some error checking on the input and
            %%%% reformat some of the input into the form needed by the constructor

            numEdges=length(source);
            % tests that source and target are same length
            assert(length(target)==numEdges,'quantumGraph:sourceTargetMismatch','Source and target must be same length');

            sourceAndTarget=[source(:) target(:)];

            % If version number is < 9.4 (i.e. pre MATLAB 2018a), then multigraphs are
            % not allowed. Check for multigraphs if using older version.
            if verLessThan('matlab','9.4')
                flag = all(size(unique(sourceAndTarget,'rows'))==size(sourceAndTarget));
                assert(flag, 'quantumGraph:multigraphVersion',...
                    'Prior to MATLAB 2018a, the digraph class does not allow two edges with same source and target! See documentation for fixes.')
            end

            % Test that the number of labeled nodes matches the number of
            % nodes in the graph
            allNodes=unique(sourceAndTarget);
            assert(length(allNodes)==allNodes(end),'quantumGraph:nodesMissing',...
                'There shouldn''t be any gaps between entries');

            % Test that the nodes are sorted properly (if not sorted
            % properly, the digraph constructor will sort them for you,
            % could cause confusion!)
            stSorted=sortrows(sourceAndTarget);
            flag = all(sourceAndTarget(:)==stSorted(:));
            assert(flag,'quantumGraph:nodesMissorted',...
                'Sources must be increasing as must all the targets of each source')


            % If LVec is scalar make all edges same length
            if isscalar(LVec)
                LVec=LVec*ones(numEdges,1);
            end
            % Test that the Length vector is same size as number of edges
            assert(length(LVec)==numEdges,'quantumGraph:LMismatch','Length of LVec must match number of edges');

            % If opts.Weight is a scalar, assign same weight to all edges.
            Weight=opts.Weight;
            if isscalar(Weight)
                Weight=Weight*ones(size(source));
            end
            % Test that the weight vector is same size as number of edges
            assert(length(Weight)==numEdges,'quantumGraph:WeightMismatch',...
                'Length of Weight must match number of edges');

            % If there is a plot coordinate function there must be a
            % discretization
            assert( isfield(opts,'plotCoordinateFcn')|| ~isempty(opts.nxVec), ...
                'quantumGraph:plotCoordsButNoCoords',...
                'Must have a discretization if setting up plot coordinates.');

            % Test that the stretch vector is same size as number of edges
            if isfield(opts,'stretch')
                assert(length(opts.stretch)==numEdges,...
                    'quantumGraph:StretchMismatch',...
                    'Length of stretch must match number of edges');
            end

            if isfield(opts,'Potential')
                assert(length(opts.potential)==numEdges,...
                    'quantumGraph:PotentialMismatch',...
                    'Length of Potential must match number of edges');
            end
            % END OF ERROR CHECKING SECTION

            % CONSTRUCT THE QUANTUM GRAPH AND OPERATORS

            % Construct the basic graph structure
            G.qg=digraph(source,target,Weight);

            % ONE LAST TEST (Can't be performed until G is defined)
            % If the length of an edge is infinite, then its target node
            % should be a leaf

            if any(isinf(LVec))
                for k=1:numEdges
                    if isinf(LVec(k))&&numEdges>1
%                        j=G.EndNodes(k,2);
                        j=G.target(k);
                        assert(G.isleaf(j),'Target node %i on infinite edge %i must be a leaf',j,k)
                        % j=G.EndNodes(k,1);
                        j = G.source(k);
                        assert(~G.isleaf(j),'Source node %i on infinite edge %i must not be a leaf',j,k)
                    end
                end
            end

            % Assign the edge lengths
            G.qg.Edges.L=LVec(:);

            % Test that the Robin coefficients are a sensible length
            nNodes=numnodes(G.qg);
            robinCoeff=opts.RobinCoeff;
            if length(robinCoeff)==nNodes
                robinCoeff=robinCoeff(:);
            elseif isscalar(robinCoeff)
                robinCoeff=robinCoeff*ones(nNodes,1);
            else
                error('quantumGraph:robinMismatch','Robin coefficient vector length must equal number of nodes')
            end

            % Make sure that the vertex condition is Dirichlet at the 
            % target node of any infinite edge

            if any(isinf(LVec))
                for k=1:numEdges
                    if isinf(LVec(k))
                        %j=G.EndNodes(k,2);
                        j = G.target(k);
                        robinCoeff(j)=nan;
                    end
                end
            end

            % Assign the Robin coefficients to the Nodes
            G.qg.Nodes.robinCoeff=robinCoeff;

            G.discretization=opts.Discretization;
            % If the nxVec is set but the discretization is set to 'None'
            % but 'nxVec' is given, remove 'nxVec'
            if (~isempty(opts.nxVec) && strcmp(G.discretization,'None'))
                opts.nxVec=[];
            end
            if any(isinf(LVec))
                if isfield(opts,'stretch')
                    stretch = opts.stretch(:);
                else
                    stretch = zeros(numEdges,1);
                    for k=1:numEdges
                        if isinf(LVec(k))
                            if strcmp(G.discretization,'Uniform')
                                stretch(k)=3.5; % Pretty arbitrary number that seemed to work well
                            elseif  strcmp(G.discretization,'Chebyshev')
                                if isscalar(opts.nxVec)
                                    stretch(k)=log(opts.nxVec);
                                else
                                    stretch(k)=log(opts.nxVec(k));
                                end
                            end
                        end
                    end
                end
                G.qg.Edges.stretch = stretch;
            end
            if (~isempty(opts.nxVec) && ~strcmp(G.discretization,'None'))
                G.addCoordinates(opts);
                G.constructIntegrationWeights;
                G.constructMatrices;
            end

            if isfield(opts,'plotCoordinateFcn')
                G.addPlotCoords(opts.plotCoordinateFcn);
            end

            if isfield(opts,'potential')
                G.addPotential(opts.potential);
            end

        end % End of constructor

    end % End of methods section.
    % All methods except the constructor are written in
    % separate m-files in the @quantumgraphs folder
end