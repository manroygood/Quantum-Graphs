function [newBranchNumber,bifLocs,NVec,LambdaVec,energyVec,bifTypeVec] = ...
    continueFromBranchPoint(dataDir,oldBranchNumber,bifNumber,direction,options)
if ~exist('options','var')
    options=continuerSet;
end

[branchDir,newBranchNumber]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=loadNLSFunctionsGraph(dataDir);

[PhiColumn,Lambda0,direction,NVecOld,LambdaVecOld,PhiOld,LambdaOld]= ...
    getFirstSolutionFromBranchpoint(dataDir,oldBranchNumber,bifNumber,fcns,direction);

if options.plotFlag;figure(1);clf;hold on;end

if options.saveFlag
    initialization='BranchPoint';
    saveFilesToDir(branchDir,initialization,oldBranchNumber,bifNumber,direction,options);
    addComment(dataDir,'branch%s continued from branch%s, bifurcation %i, in direction %i',...
        getLabel(newBranchNumber),getLabel(oldBranchNumber),bifNumber,direction);
    saveOptionsToLog(dataDir,options);
end

[NVec,LambdaVec,energyVec,bifTypeVec,bifLocs] = ...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,Lambda0,direction,options,PhiOld,LambdaOld);

continuationFinalOutput(dataDir,newBranchNumber,branchDir,bifLocs)

if options.plotFlag
    figure(2)
    plot(LambdaVecOld,NVecOld)
end