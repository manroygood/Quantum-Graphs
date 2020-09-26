function bifurcationDiagram(tag,dirNum)
datadir=fullfile('data',tag,getLabel(dirNum));
N=load(fullfile(datadir,'.branch_number'));
figure(1);clf;hold on
for k=1:N
    branchdir=fullfile(datadir,['branch' getLabel(k)]);
    if exist(branchdir,'dir')
        LambdaVec=load(fullfile(branchdir,'LambdaVec'));
        NVec=load(fullfile(branchdir,'NVec'));
        bifTypeVec=load(fullfile(branchdir,'bifTypeVec'));
        plot(LambdaVec,NVec,'color',branchcolor(branchdir))
        branchLocs=find(bifTypeVec==1);
        if ~isempty(branchLocs)
            plot(LambdaVec(branchLocs),NVec(branchLocs),'s','color',branchcolor(branchdir))
        end
        foldLocs=find(bifTypeVec==-1);
        if ~isempty(foldLocs)
            plot(LambdaVec(foldLocs),NVec(foldLocs),'^','color',branchcolor(branchdir))
        end        
    end
end
hold off
xlabel('$\Lambda$');ylabel('$N$')

% This is a nested function, since it comes before the "end" statement of
% the named function. It reads the "initialization" string in the branch
% directory and picks the appropriate color for the branch
function myColor = branchcolor(branchdir)
name=["Eigenvalue","BranchPoint","Saved","End"];
initFile=fullfile(branchdir,'initialization');
fid=fopen(initFile,'r');
str=fscanf(fid,'%s');
fclose(fid);
ind = find(startsWith(name, str, 'IgnoreCase', true), 1);
myColor=mcolor(ind);
end

end