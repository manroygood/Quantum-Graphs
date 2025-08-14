function addEnergyCurves(dataDir,opts)

arguments
    dataDir {mustBeNonzeroLengthText}
    opts.xAxis {mustBeNonzeroLengthText, ...
                mustBeMember(opts.xAxis,{'Lambda','N','Energy'})} = 'Lambda';
    opts.yAxis {mustBeNonzeroLengthText, ...
                mustBeMember(opts.yAxis,{'Lambda','N','Energy'})} = 'N';    
end

N=load(fullfile(dataDir,'.branch_number'));
Phi=load(fullfile(dataDir,'template.mat'));
fcns=load(fullfile(dataDir,'fcns.mat'));
fcns=fcns.x;

for k=1:N
    branchdir=fullfile(dataDir,['branch' getLabel(k)]);
    if exist(branchdir,'dir')
       N 
    end
end
