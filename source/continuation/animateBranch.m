function animateBranch(dataDir,branchNumber)
Phi=loadGraphTemplate(dataDir);
branchDir=getBranchDir(dataDir,branchNumber);

Lambda=load(fullfile(branchDir,'LambdaVec'));
NVec=load(fullfile(branchDir,'NVec'));
N=length(NVec);

figure
plot(Lambda,NVec)
xlabel('$\Lambda$');ylabel('$N$')
text(Lambda(1),NVec(1),'Start')
text(Lambda(end),NVec(end),'End')
figure

vec=load(fullfile(branchDir,'PhiColumn.001'));
U=zeros(length(vec),N);
U(:,1)=vec;
for k=2:N
    U(:,k)=load(fullfile(branchDir,['PhiColumn.' getLabel(k)]));
end
Phi.animatePDESolution(U,Lambda)
