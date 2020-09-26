function [V,lambda]=eig(G)
assert(G.uniform,'quantumGraph:eigNonuniform','Input graph G must be discretized under uniform discretization')
assert(G.hasDiscretization,'quantumgraph:notDiscretized','Input graph G must have been discretized')
M = G.laplacianMatrix;
[V,d]=eig(full(M));
d=diag(d); d=-abs(d); % The aforementioned cleanup
[lambda,ord]=sort(d,'descend');
lambda=abs(lambda);
V=real(V(:,ord));V(:,1)=abs(V(:,1));