function [fDeflated,matrixDeflated] = deflateFunctionsFromZero(fcns,Lambda)
% Construct deflated modifications to the function f and its linearization 
% in order to avoid computing the zero solution.


% Define the function and its gradient
myF=@(z) fcns.f(z,Lambda);
myMatrix = @(u) fcns.fLinMatrix(u,Lambda);

% Define the "deflated" versions of these functions
% These functions use the "deflation method" given in Charalampidis, 
% Kevrekidis, & Farrell to avoid finding the trivial solution
myQ=@(z) (1+1/norm(z)^2);
gradQ= @(z) (-2*z/norm(z)^4);
fDeflated=@(z)myQ(z)*myF(z);
matrixDeflated = @(z) myF(z)*transpose(gradQ(z)) + myQ(z)*myMatrix(z);