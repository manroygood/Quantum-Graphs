%% Continuation of NLS on quantum graph from linear eigenfunction
function [branchNum,bifLocs,NVec,LambdaVec,bifTypeVec] = ...
           continueFromEig(tag,dataDirNumber,eigNumber,options)
close all

if ~exist('options','var'); options=continuerSet; end

%% Load the data and assign it to the quantum graph
topDir=fullfile('data',tag);
if ~(exist(topDir,'dir'))
    fprintf('No such directory.\n') 
end

direction = 1;
dataDir=makeDataDir(tag,dataDirNumber);
[branchDir,branchNum]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=getGraphFcns(Phi);

[PhiColumn,LambdaFirst]=getFirstSolutionFromEigenfunction(dataDir,eigNumber,Phi,fcns);

if options.plotFlag; figure(1)
    clf; hold on; 
end

initialization='Eigenvalue';
saveFilesToDir(branchDir,initialization,dataDirNumber,eigNumber,options);
[NVec,LambdaVec,bifTypeVec,bifLocs]=graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,LambdaFirst,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)