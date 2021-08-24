function [branchNum,bifLocs,NVec,LambdaVec,bifTypeVec] = ...
    continueFromEnd(tag,dataDirNumber,inBranchNumber,firstorlast,NExtra,LambdaExtra,options)
if ~exist('options','var')
    options=continuerSet;
end

dataDir=makeDataDir(tag,dataDirNumber);
[branchDir,branchNum]=makeBranchDir(dataDir,options);

inputDir=fullfile(dataDir,['branch' getLabel(inBranchNumber)]);

Phi=loadGraphTemplate(dataDir);
fcns=getGraphFcns(Phi);

NVecOld=load(fullfile(inputDir,'NVec'));
LambdaVecOld=load(fullfile(inputDir,'LambdaVec'));

name=["first","last"];
ind = find(startsWith(name, firstorlast, 'IgnoreCase', true), 1);
if ind==1; pointNumber=1; else; pointNumber=length(NVecOld);end

Lambda0=LambdaVecOld(pointNumber);
N0=NVecOld(pointNumber);
pointlabel=getLabel(pointNumber);
PhiColumn=load(fullfile(inputDir,['PhiColumn.' pointlabel]));

options=continuerSet(options,'NThresh',N0+NExtra,'LambdaThresh',Lambda0-LambdaExtra);
direction=1;

if options.plotFlag;figure(1);clf;hold on;end

initialization='End';
saveFilesToDir(branchDir,initialization,dataDirNumber,pointNumber,direction,options);

[NVec,LambdaVec,bifTypeVec,bifLocs]=...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,Lambda0,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)

if options.plotFlag
    figure(2)
    plot(LambdaVecOld,NVecOld)
end