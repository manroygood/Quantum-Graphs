function fileNumber=saveHighFrequencyStandingWave(dataDir,Lambda0,edges,signs)
% Find a standing wave of a given graph and save it to a file. The graph
% must be read from a file in the directory data/<tag>/getLabel(dataDirNum)
% INPUT ARGUMENTS
% dataDir.......the subdirectory where the template is stored
% Lambda0..........(minus) the frequency of the desired standing wave. We
%                  assume that Lambda0>>1 so that the solution is localized on each edge
% edges............A list of edges supporting sech-like initial guesses
% signs............a list of the signs of the sech function on each nonzero edge


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

function Phi=initNLStanding(Phi,Lambda0,nonZeroEdges,signs)
% Finds a large-amplitude standing wave with frequency Lambda0
%
% It looks for a solution which looks like a sum of sech functions which
% are located at the centers of the edges specificied in the input argument
% "edges" and which have signs specified by the input argument "signs"

sL=sqrt(abs(Lambda0));

L=Phi.Edges.L;

for k=1:Phi.numedges
    if ismember(k,nonZeroEdges)
        spot=(k==nonZeroEdges);
        j=Phi.target(k);
        if Phi.isLeaf(j) && ~Phi.isDirichlet(j)
            x0=L(k);     % If edge kk ends in a leaf node with non-dirichlet BC at the leaf, center the guess at the end
        else
            x0=L(k)/2;   % Otherwise center the guess at the center of the edge
        end
        f = @(x) signs(spot)*sL*sech(sL*(x-x0));
    else
        f=@(x) zeros(size(x));
    end
    Phi.applyFunctionToEdge(f,k)
end
y=Phi.graph2column;
fcns=getNLSFunctionsGraph(Phi);
[fDeflated,matrixDeflated] = deflateFunctionsFromZero(fcns,Lambda0);
initTol=1e-6;
[y,~,~]=solveNewton(y,fDeflated,matrixDeflated,initTol);
Phi.column2graph(y);
end