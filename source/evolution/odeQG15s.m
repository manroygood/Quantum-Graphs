function [t,u] = odeQG15s(G,mu,F,t,u0,opts)
% Given a function f and initial condition u0, this function evolves the
% solution to du/dt =f(F,u,t) in time using a ode15s until t=tend using the
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
M = G.laplacianMatrix;
B = G.weightMatrix;
MVCA = G.vertexConditionAssignmentMatrix;
f=@(t,z) mu*(M*z) + B*F(t,z) - MVCA*mu*opts.phi(t);

odeopt = odeset('mass', B, 'masssing', 'yes', 'AbsTol', 100*opts.tol, 'RelTol', opts.tol);

[t, u] = ode15s(f, tspan, u0, odeopt);
u = u.';