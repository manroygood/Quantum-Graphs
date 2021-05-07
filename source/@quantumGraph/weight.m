function z=weight(Phi,varargin)
if nargin==1
    z=Phi.qg.Edges.Weight;
else
    z=Phi.qg.Edges.Weight(varargin{1});
end