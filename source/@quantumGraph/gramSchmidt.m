function U = gramSchmidt(G,V)
% orthonormalizes the columns of V considered as functions over the quantum
% graph G

U = zeros(size(V));

n= size(V,2);
for k = 1:n
    v = V(:,k);
    for j = 1:k-1
        v = v - G.dot(U(:,j),v)*U(:,j);
    end
    U(:,k) = v/G.norm(v);
end