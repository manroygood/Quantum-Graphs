function plotSolution(dataDir,branchNumber,solNumber)
branchDir=getBranchDir(dataDir,branchNumber);
if ischar(solNumber)
    assert(strcmp(solNumber,'last'),'solnumber string must be ''last.\n''')
    NVec=load(fullfile(branchDir,'NVec'));
    solNumber=length(NVec);
end

Phi=loadGraphTemplate(dataDir);
vec=load(fullfile(branchDir,['PhiColumn.' getLabel(solNumber)]));

if ~ismember('relinked', Phi.qg.Edges.Properties.VariableNames)
    Phi.plot(vec);
else
    [PhiX,extensionMap]=loadGraphTemplateExtension(dataDir);
    PhiX.plotPeriodicExtension(Phi,extensionMap,vec);
end