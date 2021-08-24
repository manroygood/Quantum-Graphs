function z=weight(G,varargin)
if nargin==1
    z=G.qg.Edges.Weight;
else
    z=G.qg.Edges.Weight(varargin{1});
end