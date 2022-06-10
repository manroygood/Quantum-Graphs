function status = rmBranch(dataDir,branchNumber)
% Remove the branch of the computed diagram
if nargin ==1
    branchNumber=load(fullfile(dataDir,'.branch_number'));
elseif ischar(branchNumber)
    assert(strcmp(branchNumber,'last'),'If branchNumber is a character it must be ''last''')
    branchNumber=load(fullfile(dataDir,'.branch_number'));
end
branchDir=getBranchDir(dataDir,branchNumber);
if exist(branchDir,'dir')
    rmdir(branchDir,'s');
    status=1;
else
    fprintf('No such directory.\n')
    status=0;
end