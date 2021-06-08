function [xNew,muNew,tau]=graphContinuer(fcns,ds,xStar,muStar,dotProduct,pm,dx,dmu)

% Continuation as described by Nayfeh & Balachandran
% dotProduct in x specified, and all dot products in x, alpha
% full dot product < (x1,a1) , (x2,a2) > = dotproduct(x1,x2) + beta*a1*a2
%
% xStar is assumed to be a column vector that was produced by the
% graph2column command, and dotProduct.dot should be a function that first
% runs column2graph and then uses graphdot

% tau is the sign of the determinant of the jacobian and tauOld is its
% value the previous computation
% bifFlag = true if checking for bifurcation, false if not

% Set up and solve Nayfeh/Balachandran eqn (6.1.12)
rhs = -fcns.fMu(xStar,muStar);
myMatrix = fcns.fLinMatrix(xStar,muStar);
z=myMatrix\rhs;
%[np,~,~]=countSpectrum(myMatrix);

muPrime = pm/sqrt(dotProduct.dot(z,z)+dotProduct.beta); % (6.1.14)
xPrime = muPrime*z;                                     % (6.1.13)

% Need to choose the correct sign when taking square root
if exist('dx','var')&& ~isempty(dx)
    if dotProduct.big(dx,xPrime,dmu,muPrime) < 0
        muPrime= -muPrime; xPrime = -xPrime;
    end
end

% Construct the predictors for x and mu
muGuess = muStar + ds*muPrime;
xGuess  = xStar + ds*xPrime;

% The orthogonality condition for pseudo-arclength
g=@(x,mu) ( dotProduct.big(x-xStar,xPrime,mu-muStar,muPrime) - ds );

% Call the bordered newton solver
[xNew,muNew]=graphBorderNewton(fcns,g,dotProduct,xGuess,muGuess,xPrime,muPrime);

% Testing for eigenvalue crossings
myMatrix=fcns.fLinMatrix(xNew,muNew);
tau=detSign(myMatrix);