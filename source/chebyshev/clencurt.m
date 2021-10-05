function z = clencurt(f,L)
% Uses Clenshaw-Curtis quadrature to integrate a function f over an
% interval of length L using n internal discretization points. 
% Clenshaw-Curtis quadrature is useful when doing numerical integration
% with a Chebyshev discretization. Also produces the weights and 
% coefficients used in the Clenshaw-Curtis quadrature.

n = length(f);       % Total number of discretization points including end points
N = n-1;

% % WEIGHTS
% c = zeros(n,2);
% c(1:2:n,1) = (2./[1 1-(2:2:N).^2 ])'; c(2,2) = 1;
% f1 = real(ifft([c(1:n,:);c(N:-1:2,:)]));
% w = L*([f1(1,1); 2*f1(2:N,1); f1(n,1)])/2;

% COEFFICENTS: a_k = int_0^pi f(cos(x))*cos(kx) dx
theta = pi*(0:N)/N;
dtheta = theta(2) - theta(1);

a0 = 2/pi * (dot(f,cos(0*theta)) - .5 *(f(1)*cos(0*theta(1)) +  f(n)*cos(0*theta(n)))) * dtheta;
z = a0;
eps = 10^(-16);
maxk = 10^4;

for k=2:maxk
    
    if mod(k,2)==0      % Picks out even indicies
        ak = 2/pi * (dot(f,cos(k*theta)) - .5 *(f(1)*cos(k*theta(1)) +  f(n)*cos(k*theta(n)))) * dtheta;   % Trapezoid rule 
        bk = 2*ak/(1-k^2);
        
        if abs(bk)>eps && k<maxk
            z = z + bk;                 % Summation portion of integration
        else
            z = z + .5*bk;              % End point contribution for the integration
            z = z * L/2;                % Scales result based on interval length
            break
        end
    end
end

end