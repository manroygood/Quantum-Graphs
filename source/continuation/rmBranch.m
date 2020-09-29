function rmBranch(tag,diagramNumber,branchNumber)
% Remove the branch of the computed diagram
if nargin ==2
    branchNumber=load(fullfile('data',tag,getLabel(diagramNumber),'.branch_number'));
elseif ischar(branchNumber)
    assert(strcmp(branchNumber,'last'),'If branchNumber is a character it must be ''last''')
    branchNumber=load(fullfile('data',tag,getLabel(diagramNumber),'.branch_number'));
end
branchDir=getBranchDir(tag,diagramNumber,branchNumber);
if exist(branchDir,'dir')
    rmdir(branchDir,'s');
    status=1;
else
    fprintf('No such directory.\n')
    status=0;
end