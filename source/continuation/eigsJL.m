function [vec,val] = eigsJL(G,JL,n)
% Solves the eigenvalue problem JLv=kJLv for the first n smallest eigenvalues
% where JL is a non-self adjoint operator.

nJL = size(JL,2);
B = G.weightMatrix;
BJL = zeros(nJL,nJL);
BJL(1:(nJL/2),(nJL/2+1):nJL) = B;
BJL((nJL/2+1):nJL,1:(nJL/2)) = B;

if isempty(null(full(JL)))           % If A is well conditioned
    [V,d] = eigs(JL,BJL,n,'SM');         % Use regular eig solver as it is good enough
    val = diag(real(d));
else                                 % If A is ill conditioned
    JLshift = JL + 10*BJL;               % Shift A using B so Ashift is not be singular
    [V,valperp] = eig(JLshift,BJL);      % Solves (A + 10*B)u = lambda Bu
    valdiag = diag(valperp) - 10;        % Shift evals back
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
% for k=1:n
%     vec(:,k) = vec(:,k)/G.norm(vec(:,k));    % Normalize output
% end
