%% Dumbbell Continuation program
% Computes the non-constant symmetric branch of the dumbbell graph
function [NVec,LambdaVec,bifTypeVec]=...
    dumbbellNonlinContFromEigCheb(dataDirNum,singledouble,eigNum,beta,maxTheta,LambdaThresh,NThresh,plotFlag,saveFlag)
if ~exist('saveFlag','var')||isempty(saveFlag); saveFlag=false; end
if ~exist('plotFlag','var')||isempty(plotFlag); plotFlag=true;  end

%% Load the data and assign it to the quantum graph
tag = 'DumbbellContinuation';
dataDir = fullfile('data',tag,['dumbbellEigenfunctions' get_label(dataDirNum)]);
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
[M,B] = Phi.GCrectangularCollocation;
direction = 1;
fcns = getGraphFcnsCheb(M,B);

% Form the guess % GUESS FOR WHAT?!?
epsilon = 0.001;
Phi.column2graph(phi0);
phinorm4 = Phi.norm(4);
Lambda1 = -2*phinorm4;
LambdaFirst = lambda0 + epsilon*Lambda1;
rhs = phi0.*(Lambda1+2*phi0.^2);
phi1 = (M-lambda0*speye(length(M)))\rhs;
PhiGuess = B*sqrt(epsilon)*(phi0);% + epsilon*phi1);

% Find the first solution on the branch
myF=@(z) fcns.f(z,LambdaFirst);
myMatrix = @(u) fcns.fLinMatrix(u,LambdaFirst);
% The following three functions use the "deflation method" described in
% Charalampidis, Kevrekidis, and Farrell in order to avoid landing on the
% trivial solution
myQ = @(z) (1+1/norm(B*z)^2);               % Deflation operator?
gradQ = @(z) (-2*B*z/norm(B*z)^4);
fDeflated = @(z)myQ(z)*myF(z);
matrixDeflated = @(z) myF(z)*transpose(gradQ(z)) + myQ(z)*myMatrix(z); % = Jacobian
figure(1);clf;hold on
initTol = 1e-6;
[PhiColumn,~,~] = solveNewton(PhiGuess,fDeflated,matrixDeflated,initTol);
[NVec,LambdaVec,bifTypeVec] = ...
    graphNonlinearContCheb(Phi,fcns,outputDir,PhiColumn,LambdaFirst,LambdaThresh,NThresh,beta,maxTheta,direction,saveFlag,plotFlag);
% [NVec,LambdaVec,bifTypeVec] = ...
%     graphHHBNonlinearContCheb(Phi,fcns,outputDir,PhiColumn,LambdaFirst,LambdaThresh,NThresh,beta,maxTheta,direction,saveFlag,plotFlag);