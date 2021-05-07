function z = isDirichlet(Phi,varargin)
% Tests if the jth node of Phi has Dirichlet bc
if nargin==1
    z = isnan(Phi.robinCoeff);
else
    z=isnan(Phi.robinCoeff(varargin{1}));
end