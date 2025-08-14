function [fileNumber,uComputed] = ...
    saveDeflatedStandingWaves(dataDir,Lambda,uGuess,nSolutions,uComputed)
% Find a standing wave of a given graph and save it to a file. The graph
% must be read from a file in the directory data/<tag>/getLabel(dataDirNum)
% INPUT ARGUMENTS
% dataDir.........the subdirectory where the template is stored
% Lambda..........(minus) the frequency of the desired standing wave. 
% uComputed.......an array whose columns are previously computed solutions
% uGuess..........an initial guess for the newton solver
% nSolutions......the number of additional solutions to compute and save


savedTag='saved';
initTol=1e-6;
fileNumber=zeros(nSolutions,1);
if ~exist('uComputed','var')
    uComputed=[];
end
for k=1:nSolutions

    fileNumber(k)=incrementRunNumber(savedTag,dataDir);
    fileLabel=getLabel(fileNumber(k));
    Phi=loadGraphTemplate(dataDir);
    fcns=loadNLSFunctionsGraph(dataDir);
    [fDeflated,matrixDeflated] = deflatedFunctions(Phi,fcns,Lambda,uComputed);
    [u,~,~]=solveNewton(uGuess,fDeflated,matrixDeflated,initTol);
    uComputed=[uComputed u]; %#ok<AGROW>
    
    solutionFileName=fullfile(dataDir,['savedFunction.' fileLabel]);
    frequencyFileName=fullfile(dataDir,['savedFrequency.' fileLabel]);

    save(solutionFileName,'u','-ascii','-double')
    save(frequencyFileName,'Lambda','-ascii','-double')

    fprintf('File saved to %s.\n',solutionFileName);
    fprintf('File number is %i. \n',fileNumber(k));

    addComment(dataDir,'savedFunction.%s computed via deflation of %i solutions',fileLabel,size(uComputed,2))
    addComment(dataDir);

end

end
