classdef quantumGraph < matlab.mixin.Copyable
    % Declaring this using matlab.mixin.copybable allows us to copy graph objects,
    % i.e. if g is a graph then the command 'g1=copy(g)' will create a new object
    % g1 that duplicates all of the values of g, rather than simply being a
    % second name for g
    properties
        qg      % the main quantum graph, a digraph
        discretization;
        laplacianMatrix;
    end
    methods
        function obj=quantumGraph(source,target,LVec,opts)
            % Three required
            % Constructs a quantum graph data structure
            % This is the 2021 implementation implmenting all vertex conditions via
            % ghostpoints
            % 6/23/2021 replaced input parser with argument block
            
            arguments
                source double {mustBeVector,mustBePositive,mustBeFinite}
                target double {mustBeVector,mustBePositive,mustBeFinite}
                LVec   double {mustBeVector,mustBePositive,mustBeFinite}
                opts.RobinCoeff double {mustBeVector} = 0;
                opts.Weight double {mustBeVector,mustBePositive} = 1;
                opts.Discretization char {mustBeMember(opts.Discretization,{'None','Uniform','Chebyshev'})} = 'None'
                opts.nxVec double {mustBeVector,mustBePositive,mustBeFinite} = 20;
                opts.plotCoordinateFcn function_handle
            end
            
            nSource=length(source);
            
            % If version number is < 9.4 (i.e. pre MATLAB 2018a), then multigraphs are
            % not allowed. Check for multigraphs if using older version.
            if verLessThan('matlab','9.4')
                for j=1:nSource-1
                    for k= j+1:nSource
                        if source(j)==source(k) && target(j)==target(k)
                            error('quantumGraph:multigraphVersion',...
                                'Matlab digraph class does not allow two edges with same source and target! See documentation for fixes.')
                        end
                    end
                end
            end
            

            % tests that source and target are same length
            assert(length(target)==nSource,'quantumGraph:sourceTargetMismatch','Source and target must be same length');
            
            % test that the number of labeled nodes matches the number of
            % nodes in the graph
            allNodes=unique([source(:); target(:)]);
            assert(length(allNodes)==allNodes(end),'quantumGraph:nodesMissing',...
                'There shouldn''t be any gaps between entries');
            
            % tests that the nodes are sorted properly (if not sorted
            % properly, the digraph constructor will sort them for you, which could
            % mess you up!)
            st = [source(:) target(:)];
            stSorted=sortrows(st);
            flag = all(st(:)==stSorted(:));
            assert(flag,'quantumGraph:nodesMissorted',...
                'Sources must be increasing as must all the targets of each source')

            
            if length(LVec)==1
                LVec=LVec*ones(size(source));
            end
            assert(length(LVec)==nSource,'quantumGraph:LMismatch','Length of LVec must match number of edges');
            
            
            Weight=opts.Weight;
            if length(Weight)==1
                Weight=Weight*ones(size(source));
            end
            assert(length(Weight)==nSource,'quantumGraph:WeightMismatch',...
                'Length of Weight must match number of edges');
            
            assert( isfield(opts,'plotCoordinateFcn')|| ~isempty(opts.nxVec), ...
                'quantumGraph:plotCoordsButNoCoords',...
                'Must have a discretization if setting up plot coordinates.');
            
            obj.qg=digraph(source,target,Weight);
            
            nNodes=numnodes(obj.qg);
            
            obj.qg.Edges.L=LVec(:);
            
            robinCoeff=opts.RobinCoeff;
            if length(robinCoeff)==nNodes
                robinCoeff=robinCoeff(:);
            elseif length(robinCoeff)==1
                robinCoeff=robinCoeff*ones(nNodes,1);
            elseif isempty(robinCoeff)
                robinCoeff=zeros(nNodes,1);
            else
                error('quantumGraph:robinMismatch','Robin coefficient vector wrong length')
            end
            
            obj.qg.Nodes.robinCoeff=robinCoeff;
            
            
            obj.discretization=opts.Discretization;
            % If the nxVec is set but the discretization is not, then the
            % discretization should be Uniform
            if (~isempty(opts.nxVec) && strcmp(obj.discretization,'None'))
                obj.discretization='Uniform';
            end
            
            if (~isempty(opts.nxVec) && strcmp(obj.discretization,'Uniform'))
                obj.addUniformCoordinates(opts.nxVec);
                obj.laplacianMatrix=obj.constructLaplacianMatrixUni;
            end
            
            if (~isempty(opts.nxVec) && strcmp(obj.discretization,'Chebyshev'))
                obj.addChebyshevCoordinates(opts.nxVec);
            end
            
            if isfield(opts,'plotCoordinateFcn')
                obj.addPlotCoords(opts.plotCoordinateFcn);
            end
            
        end % End of constructor
        
    end % End of methods section. All methods except the constructor are written in separate m-files in the @quantumgraphs folder
end