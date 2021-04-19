function U=solveWeidemannHerbst(A,u0,tfinal,dt,tplot)
% This is a second-order-in-time-a-la Strang modification to the Weidemann
% and Herbst splitting paper
% solves the ode u' = i (A u + |u|^2 )u
nPlot=ceil(tfinal/tplot);
nIntermediate=round(tplot/dt);
nA= length(A);

U=zeros(nA,nPlot+1);
u=u0;
U(:,1)=u0;
APlusShort  = speye(nA) + 1i*dt/4*A;
AMinusShort = speye(nA) - 1i*dt/4*A;
APlusLong  = speye(nA) + 1i*dt/2*A;
AMinusLong = speye(nA) - 1i*dt/2*A;


for j=1:nPlot
    
    u = AMinusShort\(APlusShort*u);          % Crank-Nicholson for linear part with timestep t/2
    % Combine the half time steps into full time steps except at beginning
    % and ending time
    for k=1:nIntermediate-1
        u = exp(1i*dt*2*abs(u).^2).*u;       % Evolve the phase pointwise according to the nonlinearity
        u = AMinusLong\(APlusLong*u);        % Crank-Nicholson for linear part with timestep t
    end
    u = exp(1i*dt*2*abs(u).^2).*u;           % Evolve the phase pointwise according to the nonlinearity
    u = AMinusShort\(APlusShort*u);          % Crank-Nicholson for linear part with timestep t/2
    
    U(:,j+1) = u;
    
end