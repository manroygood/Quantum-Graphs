function [t,u] = timeEvolveDH(G,f,u0,tend)
% Given a function f and initial condition u0, this function evolves the 
% solution to f(t,x) = u_xx in time using a ode15s until t=tend using the 
% given step size h. The result will be a matrix the ith row of u is the 
% solution evaluated at ith value of tvec.
    
    tspan = [0,tend];
    B = G.weightMatrix;
    odeopt = odeset('mass', B, 'masssing', 'yes', 'AbsTol', 1e-10, 'RelTol', 1e-10);
    
    [t, u] = ode15s(f, tspan, u0, odeopt);
    
    u = transpose(u);
    
end