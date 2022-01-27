function plotSolution(tag,diagramNumber,branchNumber,solNumber)
[branchDir,topDir]=getBranchDir(tag,diagramNumber,branchNumber);
if ischar(solNumber)
    assert(strcmp(solNumber,'last'),'solnumber string must be ''last.\n''')
    NVec=load(fullfile(branchDir,'NVec'));
    solNumber=length(NVec);
end

Phi=loadGraphTemplate(topDir);
vec=load(fullfile(branchDir,['PhiColumn.' getLabel(solNumber)]));

if ~ismember('relinked', Phi.qg.Edges.Properties.VariableNames)
    Phi.plot(vec);
else
    [PhiX,extensionMap]=loadGraphTemplateExtension(topDir);
    PhiX.plotPeriodicExtension(Phi,extensionMap,vec);
end