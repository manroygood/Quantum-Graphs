function flag = isCompact(G,varargin)

if nargin==1
    flag = ~any(isinf(G.L));
else
    j = varargin{1};
    flag = ~isinf(G.L(j));
end