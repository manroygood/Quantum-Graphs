function [PhiColumn,LambdaFirst]=getFirstSolutionFromEigenfunction(dataDir,eigNum,Phi,fcns)

% Set some computational paramters
epsilon=0.001;
initTol=1e-6;

% Load data
eigLabel= int2str(eigNum);
fcnFile=fullfile(dataDir,['eigenfunction.' eigLabel]);
lambdaFile=fullfile(dataDir,['lambda.' eigLabel]);
assert(exist(fcnFile,'file'),'Eigenfunction file does not exist')
assert(exist(lambdaFile,'file'),'Eigenvalue file does not exist')
phi0=load(fcnFile);
lambda0=load(lambdaFile);

% Form the guess
Phi.column2graph(phi0);
phinorm4=Phi.norm(4);
Lambda1=-2*phinorm4;
LambdaFirst=lambda0+epsilon*Lambda1;
PhiGuess = sqrt(epsilon)*(phi0);

% Define the function and its gradient
myF=@(z) fcns.f(z,LambdaFirst);
myMatrix = @(u) fcns.fLinMatrix(u,LambdaFirst);

% Define the "deflated" versions of these functions
% These functions use the "deflation method" given in Charalampidis, 
% Kevrekidis, & Farrell to avoid finding the trivial solution
myQ=@(z) (1+1/norm(z)^2);
gradQ= @(z) (-2*z/norm(z)^4);
fDeflated=@(z)myQ(z)*myF(z);
matrixDeflated = @(z) myF(z)*transpose(gradQ(z)) + myQ(z)*myMatrix(z);

% Solve for the nonlinear standing wave numerically
[PhiColumn,~,~]=solveNewton(PhiGuess,fDeflated,matrixDeflated,initTol);
