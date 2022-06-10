function [PhiColumn,LambdaFirst]=getFirstSolutionFromEigenfunction(dataDir,eigNum,Phi,fcns)

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

% Form the guess
Phi.column2graph(phi0);
phinorm4=Phi.norm(4);
Lambda1=-2*phinorm4^4;
LambdaFirst=-lambda0+epsilon*Lambda1;
PhiGuess = sqrt(epsilon)*(phi0);

[fDeflated,matrixDeflated] = deflateFunctionsFromZero(fcns,LambdaFirst);

% Solve for the nonlinear standing wave numerically
[PhiColumn,~,~]=solveNewton(PhiGuess,fDeflated,matrixDeflated,initTol);
