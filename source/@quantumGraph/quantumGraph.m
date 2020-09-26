classdef quantumGraph < matlab.mixin.Copyable 
    % Declaring this using matlab.mixin.copybable allows us to copy graph objects, 
    % i.e. if g is a graph then the command 'g1=copy(g)' will create a new object
    % g1 with all of the values of g
    properties
        qg      % the main quantum graph, a digraph
        discretization;
    end
    methods
        function obj=quantumGraph(source,target,LVec,varargin)
            % Three required 
            % Constructs a quantum graph data structure
            % This is the 2018 implementation implmenting Neumann/Kirchhoff BC via
            % ghostpoints
            nSource=length(source);
            nNodes=max([max(source) max(target)]);
            
            % The input parser section
            p=inputParser;
            defaultRobinCoeff=zeros(nNodes,1);
            defaultWeights=ones(nSource,1);
            validVectorPosNum = @(x) isnumeric(x) && min(size(x))==1 && (all(x > 0));
            validVector = @(x) isnumeric(x) && min(size(x))==1;
            expectedDiscretizations={'None','Uniform','Chebyshev'};
            defaultDiscretization='None';
            defaultPlotCoordinateFcn='None';
            defaultNxVec=[];
            
            addRequired(p,'source',validVectorPosNum);
            addRequired(p,'target',validVectorPosNum);
            addRequired(p,'Lvec',validVectorPosNum);
            addParameter(p,'RobinCoeff',defaultRobinCoeff,validVector);
            addParameter(p,'Weights',defaultWeights,validVectorPosNum);
            addParameter(p,'Discretization',defaultDiscretization,...
                @(x) any(validatestring(x,expectedDiscretizations)));
            addParameter(p,'nxVec',defaultNxVec,validVectorPosNum);
            addParameter(p,'plotCoordinateFcn',defaultPlotCoordinateFcn);
                        
            parse(p,source,target,LVec,varargin{:});
            
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
            flag = true;
            if any(sort(source)~=source)
                flag=false;
            else
                for k=1:max(source)
                    tt=target(source==k);
                    if any(sort(tt)~=tt)
                        flag=false; break;
                    end
                end
            end
            assert(flag,'quantumGraph:nodesMissorted',...
                'Sources must be increasing as must all the targets of each source')
            
            if length(LVec)==1
                LVec=LVec*ones(size(source));
            end
            assert(length(LVec)==nSource,'quantumGraph:LMismatch','Length of LVec must match number of edges');
            
            % If version number is < 9.4 (i.e. pre MATLAB 2018a), then multigraphs are
            % not allowed. Check for multigraphs if using older version.
            version=ver('MATLAB');
            if str2double(version.Version)<9.4
                for j=1:nSource-1
                    for k= j+1:nSource
                        if source(j)==source(k) && target(j)==target(k)
                            error('quantumGraph:multigraphVersion',...
                                'Matlab digraph class does not allow two edges with same source and target! See documentation for fixes.')
                        end
                    end
                end
            end
            
            weights=p.Results.Weights;
            assert(length(weights)==nSource,'quantumGraph:weightMismatch',...
                'Length of weights must match number of edges');
            
            assert(any(strcmp('plotCoordinateFcn',p.UsingDefaults)) || ~isempty(p.Results.nxVec), ...
                'quantumGraph:plotCoordsButNoCoords',...
                'Must have a discretization if setting up plot coordinates.');

            obj.qg=digraph(source,target,weights);
            %clf;plot(G,'linewidth',1.5);axis equal;title('Layout of quantum graph')
            
            nNodes=numnodes(obj.qg);
            nEdges=numedges(obj.qg);
            
            obj.qg.Edges.L=LVec(:);
            
            robinCoeff=p.Results.RobinCoeff;
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
            
            if any(isnan(robinCoeff))
                % Check that Dirichlet boundary conditions are given only at leaf nodes
                for j=1:nNodes
                    if isnan(robinCoeff(j)) && ~isLeaf(obj,j)
                        error('quantumGraph:dirichletNotLeaf',...
                            'Dirichlet boundary conditions only sensible at leaf nodes.')
                    end
                end
                % Check that all edges connected to leaf nodes point toward the leaf
                % node
                for j=1:nEdges
                    firstNode=obj.EndNodes(j,1);
                    if isnan(robinCoeff(firstNode))
                        error('quantumGraph:leafDirection',...
                            'Edges connected to Dirichlet leaf nodes must point TOWARD leaf node')
                    end
                end
                % Check that all dirichlet conditions are the last ones
                % listed. (This is so that in the chebyshev discretization only
                % the non-dirichlet nodes will be assigned values
                for j=nNodes:-1:2
                    if isnan(robinCoeff(j-1)) && ~isnan(robinCoeff(j))
                        error('quantumGraph:leafNotLast','Leaf nodes must be listed last.')
                    end
                end
            end
            
            obj.discretization=p.Results.Discretization;
            % If the nxVec is set but the discretization is not, then the
            % discretization should be Uniform
            if (~isempty(p.Results.nxVec) && strcmp(obj.discretization,'None'))
                    obj.discretization='Uniform';
            end
            
            if (~isempty(p.Results.nxVec) && strcmp(obj.discretization,'Uniform'))
                obj.addUniformCoordinates(p.Results.nxVec);
            end
            
            if (~isempty(p.Results.nxVec) && strcmp(obj.discretization,'Chebyshev'))
                obj.addChebyshevCoordinates(p.Results.nxVec);
            end
            
            if ~any(strcmp('plotCoordinateFcn',p.UsingDefaults))
                obj.addPlotCoords(p.Results.plotCoordinateFcn);
            end
            
        end % End of constructor
        
        % The Edges table
        function E = Edges(G)
            E = G.qg.Edges;
        end
        
        % The Nodes table
        function N = Nodes(G)
            N = G.qg.Nodes;
        end
        
        function len = L(G,j)
            if nargin==1
                len = G.qg.Edges.L;
            else
                len = G.qg.Edges.L(j);
            end
        end
        
        function X = x(G,j)
            if nargin==1
                X = G.qg.Edges.x;
            else
                X = G.qg.Edges.x(j);
            end
        end
        
%         function n = nx(G,j)
%             if nargin==1
%                 n = G.qg.Edges.nx;
%             else
%                 n = G.qg.Edges.nx(j);
%             end
%         end
        
        function rc = robinCoeff(G,j)
            if nargin ==1
                rc = G.qg.Nodes.robinCoeff;
            else
                rc = G.qg.Nodes.robinCoeff(j);
            end
        end
        
        function varargout = EndNodes(G,varargin)
            
            Edges=G.Edges;
            if nargin ==1
                EN = Edges.EndNodes;
            elseif nargin==2
                EN = Edges.EndNodes(varargin{1},:);
            elseif nargin ==3
                EN = Edges.EndNodes(varargin{1},varargin{2});
            end
            if nargout==1
                varargout{1}=EN;
            elseif nargout==2
                varargout{1}=EN(:,1);
                varargout{2}=EN(:,2);
            end
                
        end
        
        function gm = ghostMatrix(G,j)
            gm = G.qg.Nodes.ghostMatrix{j};
        end
        
        function yy = y(G,j)
            if nargin==1
                yy = G.qg.Edges.y;
            else
                yy = G.qg.Edges.y{j};
            end
        end
        
        % Returns the weight vector or the jth weight vector
        function w = weight(G,j)
            if nargin==1
                w = G.qg.Edges.Weight;
            else
                w = G.qg.Edges.Weight(j);
            end
        end
    end
end