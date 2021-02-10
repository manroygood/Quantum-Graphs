function [vec,valdiag] = eigJL(A,B)
% Solves the eigenvalue problem JLv=kJLv for the first n smallest eigenvalues
% where JL is a non-self adjoint operator.
% when A and B are not singular, it uses the normal function eigs but when 
% they are, it mods out by the kernal of A.

n=64;

if isempty(null(A))                 % If A is well conditioned
    [vec,val] = eigs(A,B,n,'SM');   % Use regular eig solver as it is good enough
    val = val;
    vec = vec;
else                                  % If A is ill conditioned
    
    Ashift = A + 10*B;                % Shift A using B so Ashift is not be singular
       
    [vecperp,valperp] = eig(Ashift,B);    % Solves (A + 10*B)u = lambda Bu
    valdiag = diag(valperp) - 10;                   % Shift evals back
    vec = vecperp;                        % Same evecs
    
end

for i=1:64
    if real(valdiag(i)) < 10^(-12)  % If the real component of an eigenvalue is very small...
        valdiag(i) = 1i*imag(valdiag(i));  % ... the real component is assumed to be zero
    end
end
    
    val = diag(valdiag);

end