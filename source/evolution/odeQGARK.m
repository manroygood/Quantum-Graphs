function [tVec,U] = odeQGARK(G,mu,F,tFinal,u0,dt,opts)
% Solves the PDE u_t = mu * Laplace(u) + F(t,u) on a quantum graph G
% from t = 0 to t = tFinal with step size dt
% using a form of Nørsett's three-stage, 4th order Diagonally Implicit Runge–Kutta method
% which has been adapted so that the solution at all times satisfies the
% discrete form of the vertex conditions


arguments
    G
    mu
    F,
    tFinal
    u0
    dt
    opts.phi = @(t)zeros(G.numnodes,1);
end

tVec = 0:dt:tFinal;
m=length(tVec);
n = length(u0);  
U = zeros(n,m);
U(:,1) = u0;

% Build the matrix C used in the RK method and the function f
nVC = 2*G.numedges;                        % Number of vertex conditions
L = full(G.laplacianMatrix);                % The second spatial derivative operator
P = full(G.weightMatrix);                   % The rectangular collocation or weight matrix
PBC = [P(1:(n-nVC),:); L((n-nVC+1):n,:)];   % Weight matrix diagonal with boundary data in bottom rows
L(n-nVC+1,:)=0;
MVCA = G.vertexConditionAssignmentMatrix;
f=@(t,z) mu*L*z + P*F(t,z) ;

% Define the coefficients a, b, and c that define the RK scheme
% These are all multiplied by dt to reduce number of multiplications in the
% main loop
r = roots([1 -3/2 1/2 -1/24]); 
x = max(r);
a = [x         0 0; 
     1/2-x     x 0; 
     2*x   1-4*x x]*dt;
b1 = 1/(6*(1-2*x)^2);
b2 = (3*(1-2*x)^2 - 1) / (3*(1-2*x)^2);

b = [b1; b2; b1]*dt;
c = sum(a,2);

options = optimset('Display','off'); % Tell fsolve to be quiet!

for j=2:m
    t = tVec(j);
    k1guess = f(t , u0);
    k1int = fsolve(@(x) x - f(t + c(1), u0 + a(1,1)*(PBC\(x+MVCA*opts.phi(t+c(1))))), k1guess, options);
    k1ext = PBC\(k1int+MVCA*opts.phi(t+c(1)));
    k2int = fsolve(@(x) x - f(t + c(2), u0 + a(2,1)*k1ext + a(2,2)*(PBC\(x+MVCA*opts.phi(t+c(2))))), k1int, options);
    k2ext = PBC\(k2int+MVCA*opts.phi(t+c(2)));
    k3int = fsolve(@(x) x - f(t + c(3), u0 + a(3,1)*k1ext + a(3,2)*k2ext + a(3,3)*(PBC\(x+MVCA*opts.phi(t+c(3))))), k2int, options);
    K = [k1int k2int k3int]*b;
    K((n-nVC+1):n) = 0;
    u0 = PBC\(u0+ K + MVCA*opts.phi(t+dt));
    U(:,j) = u0;
end