function fcns = saveNLSFunctionsGraph(dataDir,Phi,f)

if exist('f','var')
    assert(isa(f,'sym'),'f must be symbolic')
    fcns=getNLSFunctionsGraph(Phi,f);
else
    fcns=getNLSFunctionsGraph(Phi);
end
saveFilesToDir(dataDir,fcns)

addComment(dataDir,'Nonlinearity given by: %s',fcns.fSymbolic);
addComment(dataDir);
