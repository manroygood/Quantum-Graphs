function [t,u] = odeQG15s(G,f,u0,t)
% Given a function f and initial condition u0, this function evolves the 
% solution to f(t,x) = u_xx in time using a ode15s until t=tend using the 
% given step size h. The result will be a matrix the ith row of u is the 
% solution evaluated at ith value of tvec.
    
    if isUniform(G)
        tol = 1e-7;
    else                    % Ensures the tolerence is set as small as possible
        nx = G.Edges.nx(1);     % given how accurately the elliptic problem can
        if nx<=16               % be solved for a given number of discretization pts
            tol = 1e-13;
        elseif nx<=32
            tol = 1e-12;
        else
            tol = 1e-8;
        end
    end
    
    if length(t) == 1
        tspan = [0,t];
    else
        tspan = t;
    end
    B = G.weightMatrix;
    odeopt = odeset('mass', B, 'masssing', 'yes', 'AbsTol', 100*tol, 'RelTol', tol);
    
    [t, u] = ode15s(f, tspan, u0, odeopt);
    
    u = transpose(u);
    
end