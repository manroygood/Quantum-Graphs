function plot(G,varargin)
% Converts column vector to a graph, interpolates at the nodes, and plots

if nargin==1
    myColor=mcolor('blueish');
elseif nargin==2
    if isa(varargin{1},'double')
        column=varargin{1};
        G.column2graph(column);
        myColor=mcolor('blueish');
    elseif isa(varargin{1},'char')
        if strcmp(varargin{1},'layout')
            plotGraphLayout(G);
            return
        else
            myColor= varargin{1};
        end
    end
elseif nargin ==3
    column=varargin{1};
    G.column2graph(column);
    assert(isa(varargin{3},'char'),'Third argument should be a char array')
    myColor=varargin{3};
end


plotOnGraph(G,myColor)

