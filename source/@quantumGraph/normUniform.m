function y=normUniform(G,varargin)
% Four possible syntaxes
% y = norm(G)      Calculates the 2-norm of the y-component of G
% y = norm(G,v).   Assigns the vector v to the y component of G and then
%                  calculates the 2-norm
% y = norm(G,p)    Calculates the 2-norm of the y-component of G
% y = norm(G,v,p). Assigns the vector v to the y component of G and then
%                  calculates the 2-norm

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

nEdges=numedges(G);
weightVec=G.Edges.Weight;
dxVec=G.Edges.dx;
norm_p_vec=zeros(nEdges,1);
% Because the uniform discretization uses point [dx/2 3*dx/2 ...], each is
% at the midpoint of an interval of width dx and we can use the
% midpoint method instead of the trapezoidal method
for k=1:nEdges
    y= G.Edges.y{k};
    density = abs(y(2:end-1)).^p;  % cut off the endpoints
    norm_p_vec(k)=sum(density);    
end
y=dot(dxVec.*weightVec,norm_p_vec)^(1/p);   % Note this is a regular dot product!