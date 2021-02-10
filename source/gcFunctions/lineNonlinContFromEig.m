%% Line Continuation program
% Computes the non-constant symmetric branch of the line graph
function [NVec,LambdaVec,bifTypeVec]=...
    lineNonlinContFromEig(dataDirNum,singledouble,eigNum,beta,maxTheta,LambdaThresh,NThresh,plotFlag,saveFlag)
if ~exist('saveFlag','var')||isempty(saveFlag); saveFlag=false; end
if ~exist('plotFlag','var')||isempty(plotFlag); plotFlag=true;  end


%% Load the data and assign it to the quantum graph
tag = 'LineContinuationFinite';
dataDir = fullfile('data',tag,['lineEigenfunctions' get_label(dataDirNum)]);
suffix = [int2str(singledouble) '.' int2str(eigNum)];
fcnFile = fullfile(dataDir,['eigenfunction.' suffix]);
lambdaFile = fullfile(dataDir,['lambda.' suffix]);
phi0 = load(fcnFile);
lambda0 = load(lambdaFile);
load(fullfile(dataDir,'template')); %#ok<LOAD>

if saveFlag
    outputDir = makeOutputDirectory(tag);
    filename = fullfile(outputDir,'template');
    save(filename,'Phi');  %#ok<USENS>
end


%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes is
% calculated as positive and sometimes as negative and this screws up the
% sorting.
M = Phi.laplacianMatrix;
direction = 1;
fcns = getGraphFcns(M);

% Form the guess
epsilon=0.001;
Phi.column2graph(phi0);
phinorm4=Phi.norm(4);
Lambda1=-2*phinorm4;
LambdaFirst=lambda0+epsilon*Lambda1;
rhs=phi0.*(Lambda1+2*phi0.^2);
phi1 = (M-lambda0*speye(length(M)))\rhs;
PhiGuess = sqrt(epsilon)*(phi0);% + epsilon*phi1);

% Find the first solution on the branch
myF=@(z) fcns.f(z,LambdaFirst);
myMatrix = @(u) fcns.fLinMatrix(u,LambdaFirst);
% The following three functions use the "deflation method" described in
% Charalampidis, Kevrekidis, and Farrell in order to avoid landing on the
% trivial solution
myQ=@(z) (1+1/norm(z)^2);
gradQ= @(z) (-2*z/norm(z)^4);
fDeflated=@(z)myQ(z)*myF(z);
matrixDeflated = @(z) myF(z)*transpose(gradQ(z)) + myQ(z)*myMatrix(z);
figure(1);clf;hold on
initTol=1e-6;
[PhiColumn,~,~]=solveNewton(PhiGuess,fDeflated,matrixDeflated,initTol);
[NVec,LambdaVec,bifTypeVec]=...
    graphNonlinearCont(Phi,fcns,outputDir,PhiColumn,LambdaFirst,LambdaThresh,NThresh,beta,maxTheta,direction,saveFlag,plotFlag);
