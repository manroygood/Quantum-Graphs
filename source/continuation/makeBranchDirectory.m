function [outDir,branchNumber] = makeBranchDirectory(dataDir)

tag='branch';
branchNumber=incrementRunNumber(tag,dataDir);
branchDir=[tag getLabel(branchNumber)];

outDir=fullfile(dataDir,branchDir);
if exist(outDir,'dir')
    error('Directory already exists')
else
    mkdir(outDir)
end