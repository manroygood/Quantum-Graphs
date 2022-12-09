function [t,u] = qgde23t(G,mu,F,t,u0,opts)
% Given a function f and initial condition u0, this function evolves the
% solution to du/dt =f(F,u,t) in time using a ode23t until t=tend using the
% given step size h. The result will be a matrix the ith row of u is the
% solution evaluated at ith value of tvec.

arguments
    G
    mu
    F
    t
    u0
    opts.tol {mustBeNumeric} = 1e-6;
    opts.phi = @(t)zeros(G.numnodes,1);
end

if length(t) == 1
    tspan = [0,t];
else
    tspan = t;
end
Lvc = G.laplacianMatrixWithVC;
P0 = G.interpolationMatrixWithZeros;
MNH0 = G.nonhomogeneousVCMatrix;
f=@(t,z) mu*(Lvc*z) + P0*F(t,z) - MNH0*mu*opts.phi(t);

odeopt = odeset('mass', P0, 'masssing', 'yes', 'AbsTol', 100*opts.tol, 'RelTol', opts.tol);

[t, u] = ode23t(f, tspan, u0, odeopt);
u = u.';