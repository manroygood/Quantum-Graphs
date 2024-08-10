function plot(G,varargin)
% Converts column vector to a graph, interpolates at the nodes, and plots

assert(~strcmp(G.discretization,'None'),'Cannot plot without discretization')

nargs=nargin;
if any(isnan(G.y{1})) && nargs==1
    varargin{1}='layout';
    fprintf('No y field defined. Plotting the layout.\n')
    nargs=2;
end


if nargs==1
    myColor=mcolor('blueish');
elseif nargs==2
    if isa(varargin{1},'double')
        column=varargin{1};
        G.column2graph(column);
        myColor=mcolor('blueish');
    elseif isa(varargin{1},'char')
        if strcmp(varargin{1},'layout') 
            plotGraphLayout(G,false);
            return
        elseif strcmp(varargin{1},'mutelayout') 
            plotGraphLayout(G,true);
            return            
        else
            myColor= varargin{1};
        end
    end
elseif nargs ==3
    column=varargin{1};
    G.column2graph(column);
    assert(isa(varargin{2},'char'),'Third argument should be a char array')
    myColor=varargin{2};
end


plotOnGraph(G,myColor)

