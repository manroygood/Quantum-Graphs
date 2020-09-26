function y=norm(G,p)
% p is the exponent in the L^p norm

if ~exist('p','var')
    p=2;
end
assert(isscalar(p),'p must be a scalar')
assert(isnumeric(p),'p must be a number')
assert(p>=1,'p must be > 1')

nEdges=numedges(G);
weightVec=G.Edges.Weight;
dxVec=G.Edges.dx;
norm_p_vec=zeros(nEdges,1);
for k=1:nEdges
    
    n1=G.Edges.EndNodes(k,1);
    n2=G.Edges.EndNodes(k,2);
    y=[G.Nodes.y(n1); G.Edges.y{k}(:); G.Nodes.y(n2)];
    
    density = (abs(y(1:end-1)).^p+abs(y(2:end).^p))/2;
    % Adjustment for the half-length intervals at the two ends
    density(1)=density(1)/2;
    if ~isnan(G.Nodes.robinCoeff(n2))
        density(end)=density(end)/2;
    end
    
    norm_p_vec(k)=sum(density);
    
end
y=dot(dxVec.*weightVec,norm_p_vec)^(1/p);