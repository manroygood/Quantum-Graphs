function [vec,val] = eigs(G,n)
% Solves the eigenvalue problem Av=kBv for the first n smallest eigenvalues.
% When A and B are not singular, it uses the normal function eigs but when
% they are, it mods out by the kernal of A.
assert(G.hasDiscretization,'quantumgraph:notDiscretized','Input graph G must have been discretized')

A = G.laplacianMatrix;
B = G.weightMatrix;
vec = zeros(length(A),n);


if isempty(null(full(A)))            % If A is well conditioned
    [V,d] = eigs(A,B,n,'SM');           % Use regular eigs solver as it is good enough
    val = diag(real(d));
else                                 % If A is ill conditioned
    Ashift = A - B;                     % Shift A using B so Ashift is not be singular
    [V,d] = eigs(Ashift,B,n,'SM');      % Solves (-A + 1B)u = lambda Bu
    val = diag(real(d)) + 1 ;           % Shift evals back and neglect small imaginary component
end

k=1;

while k <= n
    if imag(d(k,k))==0              % If there was not an imaginary component...
        vec(:,k) = V(:,k);              % then associated eigenfunctions are real
        k = k+1;
    else                            % If there was an imaginary component...
        vec(:,k) = real(V(:,k));        % then associated eigenfunctions to the eigenvalue pair also have imaginary parts
        if k<n                          % and the double eigenvalue can use the real and imaginary parts at the two solutions
            vec(:,k+1) = imag(V(:,k));  % (So long as we aren't going past the number of requested eigenfunctions)
            k = k+1;
        end
        k = k+1;
    end
end

[val,p]=sort(val,'descend');
vec=vec(:,p);

[~,p]=max(abs(vec(:,1)));           % First eigenvector has no zeros (except for certain Robin coefficients).
if vec(p,1)<0                     % Normalize this eigenvector so that if it's constant, it's positive
    vec(:,1)=-vec(:,1);                    
end
for k=1:n
    vec(:,k) = vec(:,k)/G.norm(vec(:,k));    % Normalize output
end

end