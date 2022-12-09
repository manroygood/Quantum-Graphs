function [v,d] = eigs(G,n)
% Solves the eigenvalue problem Av=kBv for the first n smallest eigenvalues.
% When A and B are not singular, it uses the normal function eigs but when
% they are, it mods out by the kernal of A.
assert(G.hasDiscretization,'quantumgraph:notDiscretized','Input graph G must have been discretized')

A = G.extendWithVC(G.wideLaplacianMatrix);
B = G.extendWithZeros(G.interpolationMatrix);
[~,~,nxTot]=G.nx;
v = zeros(nxTot,n);


if isempty(null(full(A)))                  % If A is well conditioned
    [V,d] = eigs(A,B,n,'SM');        % Use regular eigs solver as it is good enough
    d = diag(real(d));
else                                  % If A is ill conditioned
    Ashift = A - B;                  % Shift A using B so Ashift is not be singular
    [V,d] = eigs(Ashift,B,n,pi/4);    % Solves (-A + 1B)u = lambda Bu
    d = diag(real(d)) + 1 ;          % Shift evals back and neglect small imaginary component
end

k=1;

while k <= n
    if imag(d(k))==0 && all(imag(V(:,k))==0)             % If there was not an imaginary component...
        v(:,k) = V(:,k);              % then associated eigenfunctions are real
        k = k+1;
    else                            % If there was an imaginary component...
        v(:,k) = real(V(:,k));        % then associated eigenfunctions to the eigenvalue pair also have imaginary parts
        if k<n                          % and the double eigenvalue can use the real and imaginary parts at the two solutions
            v(:,k+1) = imag(V(:,k));  % (So long as we aren't going past the number of requested eigenfunctions)
            k = k+1;
        end
        k = k+1;
    end
end

[d,p]=sort(d,'descend');
v=v(:,p);

[~,p]=max(abs(v(:,1)));           % First eigenvector has no zeros (except for certain Robin coefficients).
if v(p,1)<0                     % Normalize this eigenvector so that if it's constant, it's positive
    v(:,1)=-v(:,1);                    
end
for k=1:n
    v(:,k) = v(:,k)/G.norm(v(:,k));    % Normalize output
end

end