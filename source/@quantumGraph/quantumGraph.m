classdef quantumGraph < matlab.mixin.Copyable
    % Declaring this using matlab.mixin.copybable allows us to copy graph objects,
    % i.e. if g is a graph then the command 'g1=copy(g)' will create a new object
    % g1 that duplicates all of the values of g, rather than simply being a
    % second name for g
    properties
        qg      % the main quantum graph, a digraph
        discretization;
        laplacianMatrix;
        weightMatrix;
        vertexConditionAssignmentMatrix;
        explicitLaplacian;
    end
    methods
        function obj=quantumGraph(source,target,LVec,opts)
            % Three required arguments, the rest optional
            % Constructs a quantum graph data structure
            % This is the 2021 implementation implmenting all vertex conditions 
            % including Dirichlet via ghostpoints
            % 6/23/2021 replaced input parser with argument block
            % 7/1/2021 made ghost points actual data points
            
            arguments
                source double {mustBeVector,mustBePositive,mustBeFinite}
                target double {mustBeVector,mustBePositive,mustBeFinite}
                LVec   double {mustBeVector,mustBePositive,mustBeFinite}
                opts.RobinCoeff double {mustBeVector} = 0;
                opts.Weight double {mustBeVector,mustBePositive} = 1;
                opts.nodeData double {mustBeVector} = 0;
                opts.Discretization char {mustBeMember(opts.Discretization,{'None','Uniform','Chebyshev'})} = 'None'
                opts.nxVec double {mustBeVector,mustBePositive,mustBeFinite} = 20;
                opts.plotCoordinateFcn function_handle
            end
            
            %%%% Here we do some error checking on the input and
            %%%% reformat some of the input into the form needed by the constructor
            
            nSource=length(source);
            % tests that source and target are same length
            assert(length(target)==nSource,'quantumGraph:sourceTargetMismatch','Source and target must be same length');
            
            sourceAndTarget=[source(:) target(:)]; 
            
            % If version number is < 9.4 (i.e. pre MATLAB 2018a), then multigraphs are
            % not allowed. Check for multigraphs if using older version.
            if verLessThan('matlab','9.4')
                flag = all(size(unique(sourceAndTarget,'rows'))==size(sourceAndTarget));
                assert(flag, 'quantumGraph:multigraphVersion',...
                    'MATLAB digraph class does not allow two edges with same source and target! See documentation for fixes.')
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
            if length(LVec)==1
                LVec=LVec*ones(size(source));
            end
            % Test that the Length vector is same size as number of edges
            assert(length(LVec)==nSource,'quantumGraph:LMismatch','Length of LVec must match number of edges');
            
            % If opts.Weight is a scalar, assign same weight to all edges. 
            Weight=opts.Weight;
            if length(Weight)==1
                Weight=Weight*ones(size(source));
            end
            % Test that the weight vecgor is same size as number of edges
            assert(length(Weight)==nSource,'quantumGraph:WeightMismatch',...
                'Length of Weight must match number of edges');
            
            % If there is a plot coordinate function there must be a
            % discretization
            assert( isfield(opts,'plotCoordinateFcn')|| ~isempty(opts.nxVec), ...
                'quantumGraph:plotCoordsButNoCoords',...
                'Must have a discretization if setting up plot coordinates.');
            
            % Construct the basic graph structure
            obj.qg=digraph(source,target,Weight);
            
            % Assign the edge lengths
            obj.qg.Edges.L=LVec(:);
            
            % Test that the Robin coefficients are a sensible length
            nNodes=numnodes(obj.qg);
            robinCoeff=opts.RobinCoeff;
            if length(robinCoeff)==nNodes
                robinCoeff=robinCoeff(:);
            elseif length(robinCoeff)==1
                robinCoeff=robinCoeff*ones(nNodes,1);
            else
                error('quantumGraph:robinMismatch','Robin coefficient vector length must equal number of nodes')
            end
            % Assign the Robin coefficients to the Nodes
            obj.qg.Nodes.robinCoeff=robinCoeff;
            
            % Test that the node Data vector is a sensible length
            nodeData=opts.nodeData;
            if length(nodeData)==nNodes
                nodeData=nodeData(:);
            elseif length(nodeData)==1
                nodeData=nodeData*ones(nNodes,1);
            else
                error('quantumGraph:nodeDataMismatch','Node data vector length must equal number of nodes')
            end
            % Assign the node data to the Nodes
            obj.qg.Nodes.nodeData=nodeData;
            
            obj.discretization=opts.Discretization;
            % If the nxVec is set but the discretization is not, then the
            % discretization should be Uniform
            if (~isempty(opts.nxVec) && strcmp(obj.discretization,'None'))
                obj.discretization='Uniform';
            end
            
            if (~isempty(opts.nxVec) && ~strcmp(obj.discretization,'None'))
                obj.addCoordinates(opts.nxVec);
                obj.constructMatrices;
            end
            
            if isfield(opts,'plotCoordinateFcn')
                obj.addPlotCoords(opts.plotCoordinateFcn);
            end
            
        end % End of constructor
        
    end % End of methods section. All methods except the constructor are written in separate m-files in the @quantumgraphs folder
end