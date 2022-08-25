function val=hasDiscretization(G,varargin)
% Tests to see whether the quantumGraph G has a discretization associated
% with it.
% If called as G.hasDiscretization, then simply checks for the discretization
% not to be 'None'
% If called as G.hasDiscretization(<string>), then compares <string> to
% G.discretization
val = ~strcmp('None',G.discretization);
if val && nargin>1
    val = strcmp(varargin{1},G.discretization);
end