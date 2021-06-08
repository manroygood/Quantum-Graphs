function x = chebptsFirstKind(N)
% Discretizes the interval (0,1) using N Chebyshev points of the first
% kind.

x = (1 - cos( ((2* (0:(N-1))+1) * pi)/(2*N) ))/2;
x = x';

end