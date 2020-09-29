function [branchNum,bifLocs,NVec,LambdaVec,bifTypeVec] = ...
    continueFromBranchPoint(tag,dataDirNumber,branchNumber,pointNumber,direction,options)
if ~exist('options','var')
    options=continuerSet;
end

dataDir=makeDataDir(tag,dataDirNumber);
[branchDir,branchNum]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=getGraphFcns(Phi.laplacianMatrix);

[PhiColumn,Lambda0,direction,NVecOld,LambdaVecOld]= ...
    getFirstSolutionFromBranchpoint(dataDir,branchNumber,pointNumber,fcns,direction);

if options.plotFlag;figure(1);clf;hold on;end

initialization='BranchPoint';
saveFilesToDir(branchDir,initialization,dataDirNumber,branchNumber,pointNumber,direction,options);

[NVec,LambdaVec,bifTypeVec,bifLocs]=graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,Lambda0,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)

if options.plotFlag
    figure(2)
    plot(LambdaVecOld,NVecOld)
end