function savePeriodicData(dataDir,PhiX,extensionMap)

filename=fullfile(dataDir,'templateX');
save(filename,'PhiX');
nodeMap=extensionMap.nodes;
edgeMap=extensionMap.edges;
saveFilesToDir(dataDir,nodeMap,edgeMap)