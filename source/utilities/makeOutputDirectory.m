function [outDir,runNumber,topDir] = makeOutputDirectory(tag,runNumber)

if ~exist('runNumber','var')
    runNumber=incrementRunNumber(tag);
end

dataDir='data';
if ~exist(dataDir,'dir')
    mkdir(dataDir)
end

topDir=fullfile(dataDir,tag);
if ~exist(topDir,'dir')
    mkdir(topDir)
end

outDir=fullfile(topDir,getLabel(runNumber));
if exist(outDir,'dir')
    error('Directory already exists')
else
    mkdir(outDir)
end