%% Continuation of NLS on quantum graph from linear eigenfunction
function [branchNum,bifLocs,NVec,LambdaVec,energyVec,bifTypeVec] = ...
           continueFromEig(dataDir,eigNumber,options)
close all

if ~exist('options','var'); options=continuerSet; end

%% Load the data and assign it to the quantum graph

direction = 1;
[branchDir,branchNum]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=loadNLSFunctionsGraph(dataDir);

[PhiColumn,LambdaFirst]=getFirstSolutionFromEigenfunction(dataDir,eigNumber,Phi,fcns);

if options.plotFlag; figure(1)
    clf; hold on; 
end

initialization='Eigenvalue';
saveFilesToDir(branchDir,initialization,eigNumber,options);
[NVec,LambdaVec,energyVec,bifTypeVec,bifLocs] = ...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,LambdaFirst,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)