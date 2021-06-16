function z=norm(G,varargin)
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
        assert(length(varargin{1})==sum(G.nx),'normLengthMismatch','length of vector V must be compatible with graph');
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
norm_p_vec=zeros(nEdges,1);

if G.isUniform
    dxVec=G.Edges.dx;
    for k=1:nEdges
        n1=G.Edges.EndNodes(k,1);
        n2=G.Edges.EndNodes(k,2);
        y=[G.Nodes.y(n1); G.Edges.y{k}(:); G.Nodes.y(n2)];

        density = (abs(y(1:end-1)).^p+abs(y(2:end).^p))/2;
        % Adjustment for the half-length intervals at the two ends
        density(1)=density(1)/2;
        if ~isDirichlet(G,n2)
            density(end)=density(end)/2;
        end
        norm_p_vec(k)=sum(density);
    end
    z=dot(dxVec.*weightVec,norm_p_vec)^(1/p);
    
else
    [~,nxC,~]=G.nx;
    y = zeros(nxC(nEdges+1),1);
    for k = 1:nEdges
        [n1,n2] = G.adjacentNodes(k);
        y(nxC(k)+1:nxC(k+1)) = [G.Nodes.y(n1); G.Edges.y{k}; G.Nodes.y(n2)];
    end
    z = (qgdotCheb(G, abs(y).^(p/2) ,abs(y).^(p/2) ))^(1/p);
    
end