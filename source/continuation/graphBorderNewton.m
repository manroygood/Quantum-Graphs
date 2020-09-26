function [xNew,muNew]=graphBorderNewton(fcns,g,dotProduct,xGuess,muGuess,xPrime,muPrime)

tol = 1e-6;
err=1;

 
while err>tol
    M=fcns.fLinMatrix(xGuess,muGuess);
    
    % Nayfeh/Balachandran eqn (6.1.26)
    rhs = -fcns.f(xGuess,muGuess);
    z1 = M\rhs;
    
    % Eqn (6.1.27)
    rhs = -fcns.fMu(xGuess,muGuess);
    z2 = M\rhs;
    
    % Eqn (6.1.29)
    numer = - ( g(xGuess,muGuess) + dotProduct.dot(xPrime,z1) );
    denom = dotProduct.dot(xPrime, z2) + dotProduct.beta*muPrime;
    dMu = numer/denom;
    
    % Eqn (6.1.28)
    dX = z1 + dMu*z2;
    
    % Add the newton correction to the approximation
    xGuess = xGuess + dX;
    muGuess = muGuess + dMu;
    err=norm(dX)+dotProduct.beta*abs(dMu);
end

xNew = xGuess;
muNew = muGuess;