%% Continuation of NLS on quantum graph from linear eigenfunction
function [branchNum,bifLocs,NVec,LambdaVec,bifTypeVec] = ...
    continueFromSaved(tag,dataDirNum,fileNum,direction,options)
if ~exist('options','var'); options=continuerSet; end

%% Load the data and assign it to the quantum graph
topDir=fullfile('data',tag);
if ~(exist(topDir,'dir'))
    fprintf('No such directory.\n') 
end

dataDir=makeDataDir(tag,dataDirNum);
[branchDir,branchNum]=makeBranchDir(dataDir,options);

Phi=loadGraphTemplate(dataDir);
fcns=getGraphFcns(Phi.laplacianMatrix,Phi.weightMatrix);

label=getLabel(fileNum);
yFile=fullfile(dataDir,['savedFunction.' label]);
PhiColumn=load(yFile);
freqFile=fullfile(dataDir,['savedFrequency.' label]);
LambdaFirst=load(freqFile);
NN=Phi.qgdot(PhiColumn, PhiColumn);
options= continuerSet(options,'NThresh',1.02*NN,'LambdaThresh',1.02*LambdaFirst);

if options.plotFlag; figure(1)
    clf; hold on; 
end

initialization='Saved';
saveFilesToDir(branchDir,initialization,dataDirNum,fileNum,direction,options);
[NVec,LambdaVec,bifTypeVec,bifLocs]=...
    graphNonlinearCont(Phi,fcns,branchDir,PhiColumn,LambdaFirst,direction,options);
continuationFinalOutput(branchNum,branchDir,bifLocs)