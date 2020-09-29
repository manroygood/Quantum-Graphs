%% Dumbbell Laplacian program
% Computes the eigenvalues and eigenfunctions of the Laplace operator
% Saves the data to files in the directory
% data/dumbbell/getLabel(diagramNumber)
function diagramNumber=dumbbellEigenfunctionsSaveData(LHoop,LHandle,nHoop,nHandle,nToPlot)
if ~exist('nToPlot','var'); nToPlot=4;end

close all
tag='dumbbell';
dataDir=fullfile('data',tag);
if ~exist(dataDir,'dir')
    mkdir(dataDir)
end
diagramNumber=incrementRunNumber(tag);
outputDir=fullfile(dataDir,getLabel(diagramNumber));
mkdir(outputDir);

%% Set up the graph structure and coordinates of the problem
LVec=[LHoop, LHandle, LHoop];
nX=[nHoop, nHandle, nHoop];
source=[1 1 2];
target=[1 2 2];
Phi = quantumGraph(source, target,LVec,'nxVec',nX);

%% Set up coordinates on which to plot the solutions
% Note that the user has to create the plotting function
% Note further, you could also add this by adding the key-value pair
% 'PlotCoordinateFcn',@dumbbellPlotCoords to the above line of code
% Phi = quantumGraph(...

Phi.addPlotCoords(@dumbbellPlotCoords);
Phi.plot('layout')

%% Save the template to a file
filename=fullfile(outputDir,'template');
save(filename,'Phi');

%% Save a comment file
filename=fullfile(outputDir,'comment.txt');
fid=fopen(filename,'w');
fwrite(fid,'Another great quantum graph!')
fclose(fid)

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

[singles,doubles,~]=separateEigs(lambda); % No triple eigenvalue unless handle and hoops resonant
%% Save the first few multiplicity-one eigenfunctions
%% Plot the first few multiplicity-one eigenfunctions
for k=1:nToPlot
    %%
    figure
    Phi.plot(V(:,singles(k)))
    title(sprintf('(%s) $\\lambda = %0.3f$', letter(k),lambda(singles(k))));
    %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',singles(k), lambda(singles(k))));
        fcnfile=['eigenfunction.' int2str(k)];
        filename=fullfile(outputDir,fcnfile);
        eigenfunction=V(:,singles(k));
        save(filename,'eigenfunction','-ascii')
        lambdafile=['lambda.' int2str(k)];
        filename=fullfile(outputDir,lambdafile);
        eigenvalue=lambda(singles(k));
        save(filename,'eigenvalue','-ascii')
end

%% Plot the first few multiplicity-two eigenfunctions
for k=1:nToPlot/2
    %%
    figure
    [v1,~]=dumbbellResolveDoubles(V,doubles(k));
    Phi.plot(v1)
    title(sprintf('(%s) $\\lambda = %0.3f$', letter(nToPlot+k), lambda(doubles(k))));
    %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',doubles(k), lambda(doubles(k))));
        fcnfile=['eigenfunction.' int2str(nToPlot+k)];
        filename=fullfile(outputDir,fcnfile);
        eigenfunction=v1;
        save(filename,'eigenfunction','-ascii')
        lambdafile=['lambda.' int2str(nToPlot+k)];
        filename=fullfile(outputDir,lambdafile);
        eigenvalue=lambda(singles(k));
        save(filename,'eigenvalue','-ascii')
end

fprintf('Saved to directory %s.\n',outputDir)
fprintf('Run number is %i.\n',diagramNumber)