function [V,lambda]=eigs(G,varargin)
assert(G.uniform,'quantumGraph:eigNonuniform','Input graph G must be discretized under uniform discretization')
assert(G.discretized,'quantumgraph:notDiscretized','Input graph G must have been discretized')
if nargin>1
    n=varargin{1};
else
    n=10;
end
M = G.laplacianMatrix;
[V,d]=eigs(full(M),n,'smallestabs');
d=diag(d); d=-abs(d); % The aforementioned cleanup
[lambda,ord]=sort(d,'descend');
lambda=abs(lambda);
V=real(V(:,ord));V(:,1)=abs(V(:,1));