function [hhb] = HHBDetector(Phi,PhiVec,muVec)
% Detects if there is a Hamilton Hopf Bifrucation point between mu1 and mu2
%
% Parameters
% ----------
% Phi : Graph
% muVec : the two eignevalues mu1 and mu2
% PhiVec : stationary state solutions associated with muVec
%
% Outputs
% -------
% hhb : the boolean truth value for if there's a HHB between mu1 and mu2

    hhb = NaN;                          % HHB between lambda1 and lambda2? 0 = no; 1 = yes
    mu1 = muVec(1);
    mu2 = muVec(2);
    PhiCol1 = PhiVec(:,1);
    PhiCol2 = PhiVec(:,2);
    
    funcs = getGraphFcns(Phi);          % Defining our JL operator
    JL = @(z,lambda) funcs.JL(z,lambda);
    JL1 = full(JL(PhiCol1,mu1));
    JL2 = full(JL(PhiCol2,mu2));

    B = Phi.weightMatrix;               % Defining the JL operator's affiliated weight matrix
    n = length(B);
    Bjl = [B zeros(n); zeros(n) B];
    
    [~,val1] = eigsJL(Phi,JL1,Bjl);     % Finds eigenvalues for JL
    [~,val2] = eigsJL(Phi,JL2,Bjl);

    N1 = nnz(imag(val1));               % Number of imagainary eigenvalues
    N2 = nnz(imag(val2));

    % Checks if there are fewer imaginary evals
    if N1 > N2
        hhb = 1;
    else
        hhb = 0;
    end
end






function [vec,val] = eigJL(A,B)
% Solves the eigenvalue problem JLv=kJLv for the first n smallest eigenvalues
% where JL is a non-self adjoint operator.
% When A and B are not singular, it uses the normal function eigs but when 
% they are, it mods out by the kernal of A.
    
    n=64;
    val=zeros(n,1);
    
    if isempty(null(A))                 % If A is well conditioned
        [vec,val] = eigs(A,B,n,'SM');   % Use regular eig solver as it is good enough
        valdiag = diag(val);
        vec = vec;
    else                                  % If A is ill conditioned
        
        Ashift = A + 10*B;                % Shift A using B so Ashift is not be singular
           
        [vecperp,valperp] = eig(Ashift,B);    % Solves (A + 10*B)u = lambda Bu
        valdiag = diag(valperp) - 10;         % Shift evals back
        vec = vecperp;                        % Same evecs
        
    end
    
    for i=1:64
        if real(valdiag(i)) < 10^(-12)  % If the real component of an eigenvalue is very small...
            val(i) = imag(valdiag(i));  % ... the real component is assumed to be zero
        end
    end

end