function bifurcationDiagram(dataDir,opts)

arguments
    dataDir {mustBeNonzeroLengthText}
    opts.xAxis {mustBeNonzeroLengthText, ...
                mustBeMember(opts.xAxis,{'Lambda','N','Energy'})} = 'Lambda';
    opts.yAxis {mustBeNonzeroLengthText, ...
                mustBeMember(opts.yAxis,{'Lambda','N','Energy'})} = 'N';    
end

N=load(fullfile(dataDir,'.branch_number'));
figure(1);clf;hold on
for k=1:N
    branchdir=fullfile(dataDir,['branch' getLabel(k)]);
    if exist(branchdir,'dir')
        xAxisDataVec=load(fullfile(branchdir,[opts.xAxis 'Vec']));
        yAxisDataVec=load(fullfile(branchdir,[opts.yAxis 'Vec']));
        bifTypeVec=load(fullfile(branchdir,'bifTypeVec'));
        plot(xAxisDataVec,yAxisDataVec,'color',branchcolor(branchdir))
        branchLocs=find(bifTypeVec==1);
        if ~isempty(branchLocs)
            plot(xAxisDataVec(branchLocs),yAxisDataVec(branchLocs),'s','color',branchcolor(branchdir))
        end
        foldLocs=find(bifTypeVec==-1);
        if ~isempty(foldLocs)
            plot(xAxisDataVec(foldLocs),yAxisDataVec(foldLocs),'^','color',branchcolor(branchdir))
        end        
    end
end
hold off
xlabel(axisString(opts.xAxis));
ylabel(axisString(opts.yAxis))

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

function myString=axisString(myAxis)
switch myAxis
    case 'Lambda'
        myString = '$\Lambda$';
    case 'N'
        myString = '$N$';
    case 'Energy'
        myString = '$E$';
end
end