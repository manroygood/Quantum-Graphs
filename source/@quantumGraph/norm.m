function z = norm(G,varargin)
% Four possible syntaxes
% y = norm(G)      Calculates the 2-norm of the y-component of G
% y = norm(G,v).   Assigns the vector v to the y component of G and then
%                  calculates the 2-norm
% y = norm(G,p)    Calculates the 2-norm of the y-component of G
% y = norm(G,v,p). Assigns the vector v to the y component of G and then
%                  calculates the 2-norm
% p should satisfy p>1. 

if nargin==1
    p=2;
elseif nargin>1
    if length(varargin{1})>1
        [~,~,nxTot]=G.nx;
        assert(length(varargin{1})==nxTot,'normLengthMismatch',...
            'length of vector V must be compatible with graph');
        G.column2graph(varargin{1});
        if nargin>2
            p=varargin{2};
        else
            p=2;
        end
    else
        p=2;
    end
end

assert(isscalar(p),'p must be a scalar')
assert(isnumeric(p),'p must be a number')
assert(p>=1,'p must be > 1')

y=G.graph2column;
if isinf(p)
    z = max(abs(y));
else
    yToTheP=(abs(y)).^p;
    z = (G.integral(yToTheP))^(1/p);
end