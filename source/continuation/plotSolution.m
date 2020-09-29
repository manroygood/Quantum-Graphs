function plotSolution(tag,diagramNumber,branchNumber,solNumber)
[branchDir,topDir]=getBranchDir(tag,diagramNumber,branchNumber);
if ischar(solNumber)
    assert(strcmp(solNumber,'last'),'solnumber string must be ''last.\n''')
    NVec=load(fullfile(branchDir,'NVec'));
    solNumber=length(NVec);
end
    
Phi=load(fullfile(topDir,'template.mat'));Phi=Phi.Phi;
vec=load(fullfile(branchDir,['PhiColumn.' int2str(solNumber)]));
Phi.plot(vec);