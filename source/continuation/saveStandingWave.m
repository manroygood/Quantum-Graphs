function fileNumber=saveStandingWave(tag,dataDirNum,Lambda0,edges,signs)
topDir=fullfile('data',tag);
if ~(exist(topDir,'dir'))
    fprintf('No such directory.\n') 
end

dataDir=fullfile(topDir,getLabel(dataDirNum));
savedTag='saved';
fileNumber=incrementRunNumber(savedTag,dataDir);
fileLabel=getLabel(fileNumber);
Phi=loadGraphTemplate(dataDir);
Phi=initNLStanding(Phi,Lambda0,edges,signs);

y=graph2column(Phi);
eigFileName=fullfile(dataDir,['savedFunction.' fileLabel]);
freqFileName=fullfile(dataDir,['savedFrequency.' fileLabel]);

save(eigFileName,'y','-ascii','-double')
save(freqFileName,'Lambda0','-ascii','-double')

fprintf('File saved to %s.\n',eigFileName);
fprintf('File number is %i. \n',fileNumber);

end
function Phi=initNLStanding(Phi,Lambda0,edges,signs)
% Finds a large-amplitude standing wave with frequency Lambda0 
%
% It looks for a solution which looks like a sum of sech functions which
% are located at the centers of the edges specificied in the input argument
% "edges" and which have signs specified by the input argument "signs"


sL=sqrt(abs(Lambda0));

L=Phi.Edges.L;
nX=Phi.Edges.nx;
nXc=[0;cumsum(nX)];

y=zeros(sum(nX,1));

for k=1:length(edges)
    kk=edges(k);
    x0=L(kk)/2;
    j1=(nXc(kk)+1);
    j2=nXc(kk+1);
    x=Phi.Edges.x{kk};
    y(j1:j2)=signs(k)*sL*sech(sL*(x-x0));
end



M=Phi.laplacianMatrix;
fcns=getGraphFcns(M);
myF=@(z) fcns.f(z,Lambda0);
myMatrix = @(u) fcns.fLinMatrix(u,Lambda0);
initTol=1e-6;
[y,~,~]=solveNewton(y,myF,myMatrix,initTol);
Phi.column2graph(y);
end