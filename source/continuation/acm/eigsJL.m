function [vec,val] = eigsJL(G,JL,n)
% Solves the eigenvalue problem JLv=kJLv for the first n smallest eigenvalues
% where JL is a non-self adjoint operator.

nJL = size(JL,2);
B = G.weightMatrix;
BJL = zeros(nJL,nJL);
BJL(1:(nJL/2),(nJL/2+1):nJL) = B;
BJL((nJL/2+1):nJL,1:(nJL/2)) = B;

if isempty(null(full(JL)))                  % If JL is well conditioned
    [V,d] = eigs(JL,BJL,n,'SM');                % Use regular eig solver as it is good enough
    val = diag(d);
else                                        % If JL is ill conditioned
    JLshift = JL + 10*BJL;                      % Shift JL using B so JLshift is not singular
    [V,valperp] = eigs(JLshift,BJL,n,'SM');             % Solves (JL + 10*B)u = lambda Bu
    val = diag(valperp) - 10;                   % Shift evals back
end

[val,p] = sort(val,'descend');
vec = V(:,p);

% val = val(end-n+1:end);
% vec = vec(:,end-n+1:end);
% 
% [val,p] = sort(val,'descend');
% vec = V(:,p);