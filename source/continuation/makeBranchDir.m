function [branchDir,branchNum]=makeBranchDir(dataDir,options)
if options.saveFlag
    [branchDir,branchNum]=makeBranchDirectory(dataDir);
else
    branchDir=[];branchNum=[];
end