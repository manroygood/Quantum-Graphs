function z = isDirichlet(G,varargin)
% Tests if the jth node of G has Dirichlet bc
if nargin==1
    z = isnan(G.robinCoeff);
else
    z = isnan(G.robinCoeff(varargin{1}));
end