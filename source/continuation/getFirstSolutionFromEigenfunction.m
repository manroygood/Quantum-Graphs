function [PhiColumn,LambdaFirst,lambda0] = ...
    getFirstSolutionFromEigenfunction(dataDir,eigNum,Phi,fcns)

% Set some computational paramters
epsilon=0.001;
initTol=1e-6;

% Load data
eigLabel= getLabel(eigNum);
fcnFile=fullfile(dataDir,['eigenfunction.' eigLabel]);
lambdaFile=fullfile(dataDir,['lambda.' eigLabel]);
assert(exist(fcnFile,'file'),'Eigenfunction file does not exist')
assert(exist(lambdaFile,'file'),'Eigenvalue file does not exist')
phi0=load(fcnFile);
lambda0=load(lambdaFile);

[leadingCoeff,leadingExponent]=leadingMonomial(fcns.fSymbolic);
% Form the guess
Phi.column2graph(phi0);
phinorm=Phi.norm(leadingExponent);
Lambda1=-leadingCoeff*phinorm^leadingExponent;
LambdaFirst=-lambda0+epsilon*Lambda1;
PhiGuess = sqrt(epsilon)*(phi0);

[fDeflated,matrixDeflated] = deflatedFunctions(Phi,fcns,LambdaFirst);

% Solve for the nonlinear standing wave numerically
[PhiColumn,~,~]=solveNewton(PhiGuess,fDeflated,matrixDeflated,initTol);
lambda0=-lambda0;