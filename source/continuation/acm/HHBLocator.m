function [PhiBif,muBif] = HHBLocator(fcns, PhiColVec, muVec)
% After determing that there is a bifurcation point between muVec[1] and
% muVec[2], this program is then used to locate the bifurcation point muBif
% and determine its affiliated eigenfunction, PhiBif.
% 
% Parameters
% ----------
% fcns : all necessary functions associated with the cubic NLS
% muVec : initial eigenvalues on either side of HHB
% PhiColVec : stationary state solutions associated with muVec
%
% Outputs
% -------
% PhiBif : the NLS solution at the HHB
% muBif : the HHB point

    mu1 = muVec(1);
    mu2 = muVec(2);
    PhiCol1 = PhiColVec(:,1);
    PhiCol2 = PhiColVec(:,2);
    muGuess = (mu1 + mu2)/2;                    % Initial guess for HHB point
    muBif = muGuess;
    error = 10^(-6);
    
    myF = @(z,mu) fcns.f(z,mu);
    myMatrix = @(u) fcns.fLinMatrix(u,mu);
    if abs(muGuess-mu1) < abs(mu2-muGuess)      % Checks to see if muGuess is closer to mu1 than mu2
        myFGuess = @(z) myF(z,muGuess);
        myMatrixGuess = @(u) myMatrix(u,muGuess);
        [PhiGuess,~,~] = solveNewton(PhiCol1,myFGuess,myMatrixGuess,);
    else
        myFGuess = @(z) myF(z,muGuess);
        myMatrixGuess = @(u) myMatrix(u,muGuess);
        [PhiGuess,~,~] = solveNewton(PhiCol2,myFGuess,myMatrixGuess,error);
    end
    PhiBif = PhiGuess;                          % Initial guess for solution at muGuess
    
    residual = abs(mu1-mu2);
    error = 1e-8;
    maxTries = 200;
    tries = 0;
    
    while residual > error  &&  tries < maxTries
        tries = tries+1;
        
        if HHBDetector(Phi,[PhiCol1,PhiGuess],[mu1,muGuess]) == 1         % When the bifurcation is between mu1 and muGuess
            mu2 = muGuess;
            PhiCol2 = PhiGuess;
        else                                                              % When the bifurcation is between muGuess and mu2
            mu1 = muGuess;
            PhiCol1 = PhiGuess;
        end
        
        muGuess = (mu1 + mu2)/2;
        
        myF = @(z,mu) fcns.f(z,mu);
        myMatrix = @(u) fcns.fLinMatrix(u,mu);
        if abs(muGuess-mu1) < abs(m2-muGuess)
            myFGuess = @(z) myF(z,muGuess);
            myMatrixGuess = @(u) myMatrix(u,muGuess);
            [PhiGuess,~,~] = solveNewton(PhiCol1,myFGuess,myMatrixGuess,error);
        else
            myFGuess = @(z) myF(z,muGuess);
            myMatrixGuess = @(u) myMatrix(u,muGuess);
            [PhiGuess,~,~] = solveNewton(PhiCol2,myFGuess,myMatrixGuess,error);
        end
        
        residual = abs(mu1-mu2);
        muBif = muGuess;
        PhiBif = PhiGuess;
    end
    
    assert(tries<maxTries,'Newton''s method failed to converge')

end