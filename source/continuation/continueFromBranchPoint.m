function [branchNum,bifLocs,NVec,LambdaVec,energyVec,bifTypeVec] = ...
    continueFromBranchPoint(dataDir,branchNumber,bifNumber,direction,options)
if ~exist('options','var')
    options=continuerSet;
end

[branchDir,branchNum]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=loadNLSFunctionsGraph(dataDir);

[PhiColumn,Lambda0,direction,NVecOld,LambdaVecOld]= ...
    getFirstSolutionFromBranchpoint(dataDir,branchNumber,bifNumber,fcns,direction);

if options.plotFlag;figure(1);clf;hold on;end

initialization='BranchPoint';
saveFilesToDir(branchDir,initialization,branchNumber,bifNumber,direction,options);

[NVec,LambdaVec,energyVec,bifTypeVec,bifLocs] = ...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,Lambda0,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)

if options.plotFlag
    figure(2)
    plot(LambdaVecOld,NVecOld)
end