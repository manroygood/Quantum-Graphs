function continuationFinalOutput(branchNum,branchDir,bifLocs)
fprintf('Branch number %i.\n',branchNum);
fprintf('Data saved to directory %s.\n', branchDir);
if ~isempty(bifLocs)
    for k=1:length(bifLocs)
        fprintf('Branching Bifurcation at solution number %i.\n',bifLocs(k));
    end
else
    fprintf('No branching bifurcations found.\n')
end