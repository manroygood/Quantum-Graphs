function vec = loadSolution(dataDir,branchNumber,solNumber)
branchDir=getBranchDir(dataDir,branchNumber);
if ischar(solNumber)
    assert(strcmp(solNumber,'last'),'solnumber string must be ''last.\n''')
    NVec=load(fullfile(branchDir,'NVec'));
    solNumber=length(NVec);
end
vec=load(fullfile(branchDir,['PhiColumn.' getLabel(solNumber)]));