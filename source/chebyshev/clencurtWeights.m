function w = clencurtWeights(n)
% Determines the necessary weights used in the Clenshaw-Curtis quadrature.
% These weights can then be used to integrate a function f which has been
% discretized with n discretization points.

N = n-1;
c = zeros(n,2);
c(1:2:n,1) = (2./[1 1-(2:2:N).^2 ])'; c(2,2) = 1;
f = real(ifft([c(1:n,:);c(N:-1:2,:)]));
w = ([f(1,1); 2*f(2:N,1); f(n,1)]);

end