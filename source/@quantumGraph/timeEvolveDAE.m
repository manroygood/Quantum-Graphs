function [u,t] = timeEvolveDAE(G,u0,h,tend)
% Given a graph G and initial condition u0, this function evolves the
% solution to u_xx = u_t in time until t=tend using the given step size
% h. The result will be a matrix the ith row of u is the solution
% evaluated at ith value of tvec

if size(u0,1)==1    % Corrects orientation of u0
    u0=u0';
end

nEdges = length(G.L); % Number of edges
nBCs = 2*nEdges; % Number of BC conditions
told = 0;        % t_n
tnew = told;     % t_n+1
s = 4;           % Number of b_i coeff's
j = 1;           % Index for t and u
n = sum(G.nx);   % Number of x points
m = round(tend/h);      % Number of t points

u = zeros(n,m);
t = zeros(1,m);
u(:,1) = u0;
uold = u(:,1);  % u_n
unew = uold;    % u_n+1

a = [0 0 0 0; 1/2 0 0 0; 0 1/2 0 0; 0 0 1 0];
b = [1 2 2 1]./6;
c = zeros(s,1);


for i=1:s
    c(i) = sum(a(i,:));
end

A = G.laplacianMatrix;                      % The second spatial derivative operator
B = G.weightMatrix;                         % The rectangular collocation or weight matrix
C = [B(1:(n-nBCs),:); A((n-nBCs+1):n,:)];   % Weight matrix diagonal with boundary data in bottom rows
% f = @(t,z) 1i * ( A*z ); % + B*((z.*conj(z)).*z) );
f = @(t,z) A*z;

while tnew < tend
    told = tnew;
    k = zeros(n,s);
    for i=1:s
        ak = transpose(a(i,:)*transpose(k));
        k(:,i) = f(  told + c(i)*h  ,  uold + h * (C \ ak) );
    end
    K = transpose(b*transpose(k));
    unew = C\(B*uold + h * K);
%     k1 = f( told, uold );
%     k2 = f( told + .5*h, uold + .5 * h * C \ k1);
%     k3 = f( told + .5*h, uold + .5 * h *  C \ k2);
%     k4 = f( told + h, uold + h * C \ k3);
%     unew = C\( B*uold + h/6 * (k1 + 2*k2 + 2*k3 + k4) );

    tnew = told + h;
    j = j + 1;
    u(:,j) = unew;
    uold = unew;
    t(j) = tnew;
end



end