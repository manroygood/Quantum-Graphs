function plotSolution(dataDir,branchNumber,solNumber)
vec = loadSolution(dataDir,branchNumber,solNumber);

Phi=loadGraphTemplate(dataDir);
if ~ismember('relinked', Phi.qg.Edges.Properties.VariableNames)
    Phi.plot(vec);
else
    [PhiX,extensionMap]=loadGraphTemplateExtension(dataDir);
    PhiX.plotPeriodicExtension(Phi,extensionMap,vec);
end
