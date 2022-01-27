function savePeriodicData(tag,diagramNumber,PhiX,extensionMap)

topDir=fullfile('data',tag);
assert(exist(topDir,'dir'), sprintf('No directory $%s exists.',topDir)) 

dataDir=makeDataDir(tag,diagramNumber);
filename=fullfile(dataDir,'templateX');
save(filename,'PhiX');
nodeMap=extensionMap.nodes;
edgeMap=extensionMap.edges;
saveFilesToDir(dataDir,nodeMap,edgeMap)