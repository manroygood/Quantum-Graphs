function s = source(G,varargin)

s=G.Edges.EndNodes(:,1);
if nargin > 1
    s=s(varargin{1});
end