function fileNumber=saveHighFrequencyStandingWaveGraphical(dataDir,Lambda0,x0)
% This is intended for finding standing waves
% Find a standing wave of a given graph and save it to a file. The graph
% must be read from a file in the directory <dataDir>
% INPUT ARGUMENTS
% dataDir.......the subdirectory where the template is stored
% Lambda0..........(minus) the frequency of the desired standing wave. We
%                  assume that Lambda0>>1 so that the solution is localized on each edge
% x0..............The central location of the localized solution

Phi=loadGraphTemplate(dataDir);
sL = sqrt(-Lambda0);
f=@(x,y)sech(sL*sqrt((x-x0(1)).^2+(y-x0(2)).^2));
guess=Phi.applyGraphicalFunction(f);
fileNumber=saveStandingWave(dataDir,Lambda0,guess);
fileLabel=getLabel(fileNumber);


addComment(dataDir,'savedFunction.%s was created using an initial guess',fileLabel)
addComment(dataDir,'generated using the applyGraphicalFunction program')
addComment(dataDir,'with frequency %0.2f and centered at (%0.2f,%0.2f).',Lambda0,x0)
addComment(dataDir);

end