function plotSolution(tag,diagramNumber,branchNumber,solNumber)
[branchDir,topDir]=getBranchDir(tag,diagramNumber,branchNumber);
if ischar(solNumber)
    assert(strcmp(solNumber,'last'),'solnumber string must be ''last.\n''')
    NVec=load(fullfile(branchDir,'NVec'));
    solNumber=length(NVec);
end

Phi=loadGraphTemplate(topDir);
vec=load(fullfile(branchDir,['PhiColumn.' getLabel(solNumber)]));
Phi.plot(vec);