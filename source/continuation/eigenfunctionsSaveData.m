%% EigenvectorSaveData
% Computes the eigenvalues and eigenfunctions of the Laplace operator
% Saves the data to files in the directory
% data/dumbbell/getLabel(diagramNumber)
function diagramNumber=eigenfunctionsSaveData(tag,LVec,nxVec,robinCoeff,nToPlot,nDoubles,nTriples)
if ~exist('nToPlot','var'); nToPlot=4;end

close all
dataDir=fullfile('data',tag);
if ~exist(dataDir,'dir')
    mkdir(dataDir)
end
diagramNumber=incrementRunNumber(tag);
outputDir=fullfile(dataDir,getLabel(diagramNumber));
mkdir(outputDir);

%% Set up the graph structure and coordinates of the problem
templateFunction=str2func([tag 'Template']);
[source,target]=templateFunction([]);
if isempty(robinCoeff)
    robinCoeff=zeros(max(target),1);
end
Phi = quantumGraph(source, target,LVec,'nxVec',nxVec,'robinCoeff',robinCoeff);

%% Set up coordinates on which to plot the solutions
% Note that the user has to create the plotting function
% Note further, you could also add this by adding the key-value pair
% 'PlotCoordinateFcn',@dumbbellPlotCoords to the above line of code
% Phi = quantumGraph(...

plotCoordFunction=str2func([tag 'PlotCoords']);
Phi.addPlotCoords(plotCoordFunction);
Phi.plot('layout')

%% Save the template to a file
filename=fullfile(outputDir,'template');
save(filename,'Phi');

%% Save a comment file
filename=fullfile(outputDir,'comment.txt');
fid=fopen(filename,'w');
fwrite(fid,'Another great quantum graph!');
fclose(fid);

%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes
% calculated as positive and sometimes as negative and this screws up the
% sorting.
G = Phi.laplacianMatrix;
[V,d]=eig(full(G));
d=diag(d); d=-abs(d); % The aforementioned cleanup
[lambda,ord]=sort(d,'descend');
lambda=abs(lambda);
V=real(V(:,ord));V(:,1)=abs(V(:,1));

[singles,doubles,triples]=separateEigs(lambda); % No triple eigenvalue unless handle and hoops resonant

%% Plot the first few multiplicity-one eigenfunctions
for j=1:nToPlot
    %%
    figure
    Phi.plot(V(:,singles(j)))
    title(sprintf('(%s) $\\lambda = %0.3f$', letter(j),lambda(singles(j))));
    %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',singles(k), lambda(singles(k))));
    fcnfile=['eigenfunction.' int2str(j)];
    filename=fullfile(outputDir,fcnfile);
    eigenfunction=V(:,singles(j));
    save(filename,'eigenfunction','-ascii')
    lambdafile=['lambda.' int2str(j)];
    filename=fullfile(outputDir,lambdafile);
    eigenvalue=lambda(singles(j));
    save(filename,'eigenvalue','-ascii')
end

%% Plot the first few multiplicity-two eigenfunctions
if exist('nDoubles','var') && nDoubles>0 && ~isempty(doubles)
    nn=0;
    resolveString=[tag 'ResolveDoubles'];
    assert(exist(resolveString,'file'),sprintf('The function %s does not exist.',resolveString))
    resolveDoubles=str2func(resolveString);
    for j=1:nToPlot/2
        for k=1:nDoubles
            %%
            vDouble=resolveDoubles(V,doubles(j),nxVec);
            nn=nn+1;
            figure
            v1=vDouble{k};
            Phi.plot(v1)
            title(sprintf('(%s) $\\lambda = %0.3f$', letter(nToPlot+nn), lambda(doubles(j))));
            fcnfile=['eigenfunction.' int2str(nToPlot+nn)];
            filename=fullfile(outputDir,fcnfile);
            save(filename,'v1','-ascii')
            lambdafile=['lambda.' int2str(nToPlot+nn)];
            filename=fullfile(outputDir,lambdafile);
            eigenvalue=lambda(singles(j));
            save(filename,'eigenvalue','-ascii')
        end
    end
end
%% Plot the first few multiplicity-two eigenfunctions
if exist('nTriples','var') && nTriples>0 && ~isempty(triples)
    nn=0;
    resolveString=[tag 'ResolveTriples'];
    assert(exist(resolveString,'file'),sprintf('The function %s does not exist.',resolveString))
    resolveTriples=str2func(resolveString);
    for j=1:nToPlot/2
        for k=1:nTriples
            %%
            vTriple=resolveTriples(V,triples(j));
            nn=nn+1;
            figure
            v1=vTriple{k};
            Phi.plot(v1)
            title(sprintf('(%s) $\\lambda = %0.3f$', letter(nToPlot+nn), lambda(triples(j))));
            fcnfile=['eigenfunction.' int2str(nToPlot+nn)];
            filename=fullfile(outputDir,fcnfile);
            save(filename,'v1','-ascii')
            lambdafile=['lambda.' int2str(nToPlot+nn)];
            filename=fullfile(outputDir,lambdafile);
            eigenvalue=lambda(singles(j));
            save(filename,'eigenvalue','-ascii')
        end
    end
end
fprintf('Saved to directory %s.\n',outputDir)
fprintf('Run number is %i.\n',diagramNumber)