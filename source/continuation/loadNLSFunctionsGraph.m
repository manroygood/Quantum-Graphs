function fcns=loadNLSFunctionsGraph(dataDir)

filename=fullfile(dataDir,"fcns.mat");
fcns=load(filename);
fcns=fcns.x;