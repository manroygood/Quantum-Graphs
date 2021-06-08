function D=chebyshevDeriv(n,l)
% Calculate the Chebyshev differentiation matrix of size n x n
% on an interval of length l.
N=n-1;

if N==0
    D=0;
    x=1;
    return
end

x = cos(pi*(0:N)/N)';
c = [2; ones(N-1,1); 2].*(-1).^(0:N)';
X = repmat(x,1,N+1);
dX = X-X';
D = (c*(1./c)')./(dX+(eye(N+1)));   % off-diagonal entries
D = D - diag(sum(D'));              % diagonal entries
D = 2/l*D;                          % rescaling for length of interval
end