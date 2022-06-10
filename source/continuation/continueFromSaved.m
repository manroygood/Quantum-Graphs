%% Continuation of NLS on quantum graph from linear eigenfunction
function [branchNum,bifLocs,NVec,LambdaVec,energyVec,bifTypeVec] = ...
    continueFromSaved(dataDir,fileNum,direction,options)
if ~exist('options','var'); options=continuerSet; end

%% Load the data and assign it to the quantum graph
[branchDir,branchNum]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=getNLSFunctionsGraph(Phi);

label=getLabel(fileNum);
yFile=fullfile(dataDir,['savedFunction.' label]);
PhiColumn=load(yFile);
freqFile=fullfile(dataDir,['savedFrequency.' label]);
LambdaFirst=load(freqFile);
NN=Phi.dot(PhiColumn, PhiColumn);
NT=max(options.NThresh,1.02*NN);
options= continuerSet(options,'NThresh',NT,'LambdaThresh',1.02*LambdaFirst);

if options.plotFlag; figure(1)
    clf; hold on; 
end

initialization='Saved';
saveFilesToDir(branchDir,initialization,fileNum,direction,options);
[NVec,LambdaVec,energyVec,bifTypeVec,bifLocs] = ...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,LambdaFirst,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)