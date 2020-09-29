function [branchDir,topDir]=getBranchDir(tag,diagramNumber,branchNumber)
topDir=fullfile('data',tag,getLabel(diagramNumber));
branchDir=fullfile(topDir,['branch' getLabel(branchNumber)]);
