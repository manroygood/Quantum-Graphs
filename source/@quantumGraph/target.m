function t = target(G,varargin)

t=G.Edges.EndNodes(:,2);
if nargin > 1
    t=t(varargin{1});
end