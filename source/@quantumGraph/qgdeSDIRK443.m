function [tVec,U] = qgdeSDIRK443(G,mu,F,tFinal,u0,dt,opts)
% Solves the PDE u_t = mu * Laplace(u) + F(u) on a quantum graph G
% from t = 0 to t = tFinal with step size dt
% using a version of the scheme (4,4,3) from 
% Ascher, Ruuth, Spiteri 1997 IMEX Runge-Kutta Schemes paper
% modified to keep the solution in the function space

arguments
    G
    mu
    F
    tFinal
    u0
    dt
    opts.nSkip = 1;
end
nSkip = opts.nSkip;

tVec = 0:nSkip*dt:tFinal;
nSteps= 1 + tFinal/dt;
n = length(u0);  
U = zeros(n,length(tVec));
U(:,1) = u0;

% Define the coefficients A and Ahat that define the IMEX-SDIRK scheme
% These are multiplied by dt to reduce number of multiplications in the
% main loop and simplify the code.

A = [ 1/2    0   0   0
      1/6  1/2   0   0
     -1/2  1/2 1/2   0
      3/2 -3/2 1/2 1/2]*dt;

Ahat = [ 18   0  0   0
         22   2  0   0
         30 -30 18   0
          9  63 27 -63]*dt/36;

Lvc = G.laplacianMatrixWithVC;
L0  = G.laplacianMatrixWithZeros;
Pvc = G.interpolationMatrixWithVC;
P0  = G.interpolationMatrixWithZeros;
P1 = Pvc -mu*A(1,1)*Lvc;

column=1;
for j=2:nSteps
    K1hat = Pvc\(P0*F(u0));
    u1 = u0 + Ahat(1,1)*K1hat;
    K1 = P1 \ ( mu*L0*u1);
    u1 = u1+  A(1,1)*K1 ;

    K2hat = Pvc\(P0*F(u1));
    u2 = u0 + A(2,1)*K1 + [K1hat K2hat]*Ahat(2,1:2)';
    K2 = P1 \ ( mu*L0*u2);
    u2 = u2 + A(2,2)*K2 ;

    K3hat = Pvc\(P0*F(u2));
    u3 = u0 + [K1 K2]*A(3,1:2)' + [K1hat K2hat K3hat]*Ahat(3,1:3)';
    K3 = P1 \ ( mu*L0* u3);
    u3 = u3 + A(3,3)*K3;    

    K4hat = Pvc\(P0*F(u3));
    u4 = u0 + [ K1 K2 K3 ]*A(4,1:3)' + [K1hat K2hat K3hat K4hat]*Ahat(4,1:4)';
    K4 = P1 \ ( mu*L0*u4);
    u0 = u4 + A(4,4)*K4;    
    if mod(j,nSkip)==1
        column=column+1;
        U(:,column) = u0;
    end
end