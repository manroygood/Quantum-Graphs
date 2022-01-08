function [t,u] = timeEvolveDH(G,f,u0,tend)
% Given a function f and initial condition u0, this function evolves the 
% solution to f(t,x) = u_xx in time using a ode15s until t=tend using the 
% given step size h. The result will be a matrix the ith row of u is the 
% solution evaluated at ith value of tvec.
    
    if isUniform(G)
        tol = 10-07;
    else                    % Ensures the tolerence is set as small as possible
        nx = G.Edges.nx(1);     % given how accurately the elliptic problem can
        if nx<=16               % be solved for a given number of discretization pts
            tol = 10^-13;
        elseif nx<=32
            tol = 10^-12;
        else
            tol = 10^-08;
        end
    end
    
    tspan = [0,tend];
    B = G.weightMatrix;      
    odeopt = odeset('mass', B, 'masssing', 'yes', 'AbsTol', tol, 'RelTol', tol);
    
    [t, u] = ode15s(f, tspan, u0, odeopt);
    
    u = transpose(u);
    
end