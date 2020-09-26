function removeBranch(tag,diagramNumber,branchNumber)
% Remove the branch of the computed diagram
branchDir=fullfile(tag,getLabel(diagramNumber),['branch' getLabel(branchNumber)]);
rmdir(branchDir,'s');