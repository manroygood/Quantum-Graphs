function [t,u] = odeQGARK(G,f,u0,h,tend)
% Given a graph G, function f and initial condition u0, this function 
% evolves the solution to f(t,x) = u_xx in time using a 2nd, 4th or 8th
% order scheme until t=tend using the given step size h. The result will be
% a matrix the ith row of u is the solution evaluated at ith value of tvec.

told = 0;        % t_n
tnew = told;     % t_n+1
s = 3;           % Number of b_i coeff's
j = 1;           % Index for t and u
m = round(tend/h);      % Number of t points
n = length(u0);         % Number of x points

nEdges = length(G.L);   % Number of edges
nBCs = 2*nEdges;        % Number of BC conditions
A = full(G.laplacianMatrix);                % The second spatial derivative operator
B = full(G.weightMatrix);                   % The rectangular collocation or weight matrix
C = [B(1:(n-nBCs),:); A((n-nBCs+1):n,:)];   % Weight matrix diagonal with boundary data in bottom rows

if size(u0,1)==1    % Corrects orientation of u0
    u0=u0';
end

u = zeros(n,m);
t = zeros(1,m);
u(:,1) = u0;
uold = u(:,1);      % u_n

x = 1.06858;
a = [x         0 0; 
     1/2-x     x 0; 
     2*x   1-4*x x];
b1 = 1/(6*(1-2*x)^2);
b2 = (3*(1-2*x)^2 - 1) / (3*(1-2*x)^2);
b3 = b1;
b = [b1 b2 b3];
c = zeros(s,1);

for i=1:s
    c(i) = sum(a(i,:));
end


while tnew < tend
    told = tnew;
    
    k1guess = f(told , uold);
    k1 = fsolve(@(x) x - f(told + c(1)*h, uold + a(1,1)*h*(C\x)), k1guess);
    k2 = fsolve(@(x) x - f(told + c(2)*h, uold + a(2,1)*h*(C\k1) + a(2,2)*h*(C\x)), k1);
    k3 = fsolve(@(x) x - f(told + c(3)*h, uold + a(3,1)*h*(C\k1) + a(3,2)*h*(C\k2) + a(3,3)*h*(C\x)), k2);
    
    k = [transpose(k1); transpose(k2); transpose(k3)];    
    
    K = transpose(b*k);
    K((n-nBCs+1):n) = 0;
    unew = uold + C\(h*K);
    tnew = told + h;
    
    j = j + 1;
    u(:,j) = unew;
    uold = unew;
    t(j) = tnew;
end

end
