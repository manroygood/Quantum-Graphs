function fileNumber=saveHighFrequencyStandingWaveGraphical(dataDir,Lambda0,x0)
% This is intended for finding standing waves
% Find a standing wave of a given graph and save it to a file. The graph
% must be read from a file in the directory <dataDir>
% INPUT ARGUMENTS
% dataDir.......the subdirectory where the template is stored
% Lambda0..........(minus) the frequency of the desired standing wave. We
%                  assume that Lambda0>>1 so that the solution is localized on each edge
% x0..............The central location of the localized solution

savedTag='saved';
fileNumber=incrementRunNumber(savedTag,dataDir);
fileLabel=getLabel(fileNumber);
Phi=loadGraphTemplate(dataDir);
Phi=initNLStandingGraphical(Phi,Lambda0,x0);

y=graph2column(Phi);
eigFileName=fullfile(dataDir,['savedFunction.' fileLabel]);
freqFileName=fullfile(dataDir,['savedFrequency.' fileLabel]);

save(eigFileName,'y','-ascii','-double')
save(freqFileName,'Lambda0','-ascii','-double')

fprintf('File saved to %s.\n',eigFileName);
fprintf('File number is %i. \n',fileNumber);

addComment(dataDir,'savedFunction.%s has support localized  on ',fileLabel)
for k=1:length(edges)
    if signs(k)==1; s = '+1'; else; s = '-1'; end
    addComment(dataDir,'Edge #%i, with sign %2',edges(k),s);
end
addComment(dataDir);

end

function Phi=initNLStandingGraphical(Phi,Lambda0,x0)
% Finds a large-amplitude standing wave with frequency Lambda0
%
% It looks for a solution which looks like a sum of sech functions which
% are located at the centers of the edges specificied in the input argument
% "edges" and which have signs specified by the input argument "signs"

sL=sqrt(abs(Lambda0));

f=@(x,y)sech(sL*sqrt((x-x0(1)).^2+(y-x0(2)).^2));
Phi.applyGraphicalFunction(f);

y=Phi.graph2column;
fcns=getNLSFunctionsGraph(Phi);
[fDeflated,matrixDeflated] = deflateFunctionsFromZero(fcns,Lambda0);
initTol=1e-6;
[y,~,~]=solveNewton(y,fDeflated,matrixDeflated,initTol);
Phi.column2graph(y);
end