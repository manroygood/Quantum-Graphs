function fileNumber=saveDumbbellStandingWave(dataDirNum,Lambda0,edges,signs)
topDir=fullfile('data/dumbbell');
if ~(exist(topDir,'dir'))
    fprintf('No such directory.\n') 
end

dataDir=fullfile(topDir,getLabel(dataDirNum));
tag='saved';
fileNumber=incrementRunNumber(tag,dataDir);
fileLabel=getLabel(fileNumber);
Phi=loadGraphTemplate(dataDir);
Phi=initPhiNLDumbbell(Phi,Lambda0,edges,signs);

y=graph2column(Phi);
eigFileName=fullfile(dataDir,['savedFunction.' fileLabel]);
freqFileName=fullfile(dataDir,['savedFrequency.' fileLabel]);

save(eigFileName,'y','-ascii','-double')
save(freqFileName,'Lambda0','-ascii','-double')

fprintf('File saved to %s.\n',eigFileName);
fprintf('File number is %i. \n',fileNumber);
Phi.addPlotCoords(@dumbbellPlotCoords);
Phi.plot;