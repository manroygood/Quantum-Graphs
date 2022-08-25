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

[PhiColumn,LambdaFirst,LambdaOld] = ...
    getFirstSolutionFromEigenfunction(dataDir,eigNumber,Phi,fcns);

if options.plotFlag; figure(1)
    clf; hold on;
end

if options.saveFlag
    addComment(dataDir,'branch%s continued from eigenfunction.%s',...
        getLabel(branchNum),getLabel(eigNumber))
    saveOptionsToLog(dataDir,options);
    initialization='Eigenvalue';
    saveFilesToDir(branchDir,initialization,eigNumber,options);
end

PhiOld = zeros(length(PhiColumn),1);

[NVec,LambdaVec,energyVec,bifTypeVec,bifLocs] = ...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,LambdaFirst,direction,options,PhiOld,LambdaOld);
continuationFinalOutput(dataDir,branchNum,branchDir,bifLocs)