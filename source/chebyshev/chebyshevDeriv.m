function D=chebyshevDeriv(n,L)
% Calculate the Chebyshev differentiation matrix of size n x n
% on an interval of length L.
N=n-1;

if N==0
    D=0;
    return
end

s = cos(pi*(N:-1:0)/N)';
c = [2; ones(N-1,1); 2].*(-1).^(0:N)';
S = repmat(s,1,N+1);
dX = S-S';
D = (c*(1./c)')./(dX+(eye(N+1)));   % off-diagonal entries
D = D - diag(sum(D,2));             % diagonal entries
D = 2/L*D;                          % rescaling for length of interval

end