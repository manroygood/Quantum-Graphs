%% Continuation of NLS on quantum graph from saved solution
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
options= continuerSet(options,'NThresh',NT);%,'LambdaThresh',1.02*LambdaFirst);

if options.plotFlag; figure(1)
    clf; hold on;
end

if options.saveFlag
    initialization='Saved';
    saveFilesToDir(branchDir,initialization,fileNum,direction,options);
    addComment(dataDir,'branch%s continued from savedFunction.%s in direction %i',...
        getLabel(branchNum),label,direction)
    saveOptionsToLog(dataDir,options);
end

[NVec,LambdaVec,energyVec,bifTypeVec,bifLocs] = ...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,LambdaFirst,direction,options);
continuationFinalOutput(dataDir,branchNum,branchDir,bifLocs)