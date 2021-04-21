function Phi0vector=shiftedState6p2(Phi,x0,mu)
% Note that this assigns the shifted state to the graph Phi

% This is the modification given by equation (6.2) of Kairzhan, Pelinovsky,
% Goodman
fEdge1 = @(x)sech(x-x0).*exp(-mu*x);
Phi.applyFunctionToEdge(fEdge1,1);

fEdge2 = @(x)sech(x-x0).*exp(2*mu*x);
Phi.applyFunctionToEdge(fEdge2,2);

fEdge3 = @(x)sech(x-x0);
Phi.applyFunctionToEdge(fEdge3,3);

Phi0vector=Phi.graph2column;