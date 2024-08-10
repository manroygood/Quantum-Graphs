function [fDeflated,matrixDeflated] = deflatedFunctions(G,fcns,Lambda,uComputed)
% Construct deflated modifications to the function f and its linearization
% in order to avoid computing the zero solution.


% Define the function and its gradient
myF=@(u) fcns.f(u,Lambda);
myMatrix = @(u) fcns.fLinMatrix(u,Lambda);

% Define the "deflated" versions of these functions
% These functions use the "deflation method" given in Charalampidis,
% Kevrekidis, & Farrell to avoid finding the trivial solution

if exist('uComputed','var') && ~isempty(uComputed)
    myQ=@(u)Q(G,u,uComputed);
    myGradQ= @(u)gradQ(G,u,uComputed);
else
    myQ=@(u)Q(G,u);
    myGradQ= @(u)gradQ(G,u);
end
fDeflated=@(u)myQ(u)*myF(u);
matrixDeflated = @(u) myF(u)*transpose(myGradQ(u)) + myQ(u)*myMatrix(u);

end


function z=Q(G,u,uComputed)
z = (1+1/G.norm(u)^2);
if exist('uComputed','var')
    for p = 1:size(uComputed,2)
        z = z.*(1+1/G.norm(u-uComputed(:,p))^2);
    end
end
end

function  z=gradQ(G,u,uComputed)
weightVector = G.integrationWeight2column;
nn = G.norm(u);
if exist('uComputed','var')
    z = u/(nn^2+nn^4);
    for p = 1:size(uComputed,2)
        nn = G.norm(u-uComputed(:,p));
        z = z+(u-uComputed(:,p))/(nn^2+nn^4);
    end
    z = -2*Q(G,u,uComputed)*weightVector.*z;
else
    z = -2*weightVector.*u/nn^4;
end
end