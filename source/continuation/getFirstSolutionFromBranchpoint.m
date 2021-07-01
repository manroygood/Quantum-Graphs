function [PhiColumn,Lambda0,direction,NVecOld,LambdaVecOld]= ...
    getFirstSolutionFromBranchpoint(dataDir,branchNumber,pointNumber,fcns,direction)

initTol=1e-6;
branchDataDir=fullfile(dataDir,['branch' getLabel(branchNumber)]);
assert(exist(branchDataDir,'dir'),'No such branch file exists')

NVecOld=load(fullfile(branchDataDir,'NVec'));
LambdaVecOld=load(fullfile(branchDataDir,'LambdaVec'));
LambdaOld=LambdaVecOld(pointNumber);
pointlabel=getLabel(pointNumber);
PhiOld=load(fullfile(branchDataDir,['PhiColumn.' pointlabel]));
dPhi = load(fullfile(branchDataDir,['PhiPerturbation.' pointlabel '.mat']));dPhi=dPhi.xPerturbation;
dLambda = load(fullfile(branchDataDir,['LambdaPerturbation.' pointlabel '.mat']));dLambda=dLambda.LambdaPerturbation;

scaleFactor=1/8; % TRY FUDGING THIS
dPhi=dPhi*scaleFactor;
dLambda=dLambda*scaleFactor;

if direction*dLambda<0
    dLambda=-dLambda;
    dPhi=-dPhi;
end
PhiGuess=PhiOld+ dPhi;
Lambda0 = LambdaOld+dLambda;
myF=@(z) fcns.f(z,Lambda0);
myMatrix = @(u) fcns.fLinMatrix(u,Lambda0);

[PhiColumn,~,~]=solveNewton(PhiGuess,myF,myMatrix,initTol);
direction=-direction;

 
