function x = chebptsSecondKind(N)
% Discretizes the interval [0,1] using N+2 Chebyshev points of the second
% kind. This means we will have N internal discretization points as well as
% the two end points.

N=N+2;      % Total number of discretization points including end points

x = (cos( pi*(0:(N-1))/(N-1) ) + 1)/2;

end