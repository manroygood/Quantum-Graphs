function dataDir=createDataDirectories(tag,diagramNumber)

topDir=fullfile('data',tag);
if ~exist(topDir,'dir')
    mkdir(topDir)
end
dataDir=fullfile(topDir,getLabel(diagramNumber));
if ~exist(dataDir,'dir')
    mkdir(dataDir);
end