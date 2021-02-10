function [vec,val] = eigQG(A,B,n)
% Solves the eigenvalue problem Av=kBv for the first n smallest eigenvalues.
% When A and B are not singular, it uses the normal function eigs but when 
% they are, it mods out by the kernal of A.



if isempty(null(A))                   % If A is well conditioned
    [vec,val] = eigs(-A,B,n,'SM');    % Use regular eigs solver as it is good enough
    val = real(val);
    vec = real(vec);
else                                  % If A is ill conditioned

    Ashift = -A + B;                  % Shift A using B so Ashift is not be singular
       
    [vecperp,valperp] = eigs(Ashift,B,n,'SM');  % Solves (-A + 1B)u = lambda Bu
    val = real(valperp) - 1;                    % Shift evals back and neglect small imaginary component
    vec = real(vecperp);                        % Same evecs up to a small imaginary component

    if sum(abs(imag(valperp)))>10^(-9)
        disp('Imaginary portion of eigenvalues is non-negligable.')
    end
    
end

end