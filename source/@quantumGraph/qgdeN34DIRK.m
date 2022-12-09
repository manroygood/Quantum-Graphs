function [tVec,U] = qgdeN34DIRK(G,mu,F,tFinal,u0,dt,opts)
% Solves the PDE u_t = mu * Laplace(u) + F(t,u) on a quantum graph G
% from t = 0 to t = tFinal with step size dt
% using a form of Nørsett's three-stage, 4th order Diagonally Implicit Runge–Kutta method
% which has been adapted so that the solution at all times satisfies the
% discrete form of the vertex conditions

arguments
    G
    mu
    F
    tFinal
    u0
    dt
    opts.phi = @(t)zeros(G.numnodes,1);
end
phi = opts.phi;

tVec = 0:dt:tFinal;
nSteps=length(tVec);
n = length(u0);  
U = zeros(n,nSteps);
U(:,1) = u0;

L0 =   G.laplacianMatrixWithZeros;
Pvc =  G.interpolationMatrixWithVC;
P0 =   G.interpolationMatrixWithZeros;
MNH0 = G.nonhomogeneousVCMatrix;

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

P1 = G.extendWithVC(G.interpolationMatrix-mu*a(1,1)*G.wideLaplacianMatrix);
P2 = G.extendWithVC(G.interpolationMatrix-mu*a(2,2)*G.wideLaplacianMatrix);
P3 = G.extendWithVC(G.interpolationMatrix-mu*a(3,3)*G.wideLaplacianMatrix);

options = optimset('Display','off'); % Tell fsolve to be quiet!

for j=2:nSteps
    t = tVec(j);
    k1guess = Pvc\(mu*L0*u0 + P0*F(t,u0) + MNH0*phi(t));
    f1 = @(x)( -P1*x + mu*L0*u0                           + P0*F(t+c(1),u0 + a(1,1)*x)                         + MNH0*phi(t+c(1))) ;
    k1 = fsolve(f1,k1guess,options);
    f2 = @(x)( -P2*x + mu*L0*(u0 + a(2,1)*k1)             + P0*F(t+c(2),u0 + a(2,1)*k1 + a(2,2)*x)             + MNH0*phi(t+c(2))) ;
    k2 = fsolve(f2,k1,options);
    f3 = @(x)( -P3*x + mu*L0*(u0 + a(3,1)*k1 + a(3,2)*k2) + P0*F(t+c(3),u0 + a(3,1)*k1 + a(3,2)*k2 + a(3,3)*x) + MNH0*phi(t+c(3))) ;
    k3 = fsolve(f3,k2,options);
    u0 = Pvc \ ( P0*(u0 + b(1)*k1 + b(2)*k2 + b(3)*k3) + MNH0*phi(t+dt));
    U(:,j) = u0;
end