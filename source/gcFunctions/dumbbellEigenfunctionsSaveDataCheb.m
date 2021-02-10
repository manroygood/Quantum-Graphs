%% Dumbbell Laplacian program with Chebychev points
% Computes the eigenvalues and eigenfunctions of the Laplace operator
function dumbbellEigenfunctionsSaveDataCheb

saveFlag=true;
if saveFlag
    datadir='data/DumbbellContinuation';
    tag='dumbbellEigenfunctions';
    runNumber=incrementRunNumber(tag);
    outputDir=[datadir '/' tag get_label(runNumber)];
    mkdir(outputDir);
end

%% Set up the graph structure and coordinates of the problem
LVec=[2*pi,4, 2*pi];
n=32; nX=[n n n];
robinCoeff = [0 0];
Phi = quantumGraph([1 1 2],[1 2 2],LVec,'nxVec',nX,'RobinCoeff',robinCoeff);

if saveFlag
    filename=fullfile(outputDir,'template');
    save(filename,'Phi');
end


%% Calculate and plot the secular determinant of the quantum graph
f = GCsecularDet(Phi);
fplot(f,[0 4])


%% Set up coordinates on which to plot the solutions
% Note that the user has to create the plotting function
% Note further, you could also add this by adding the key-value pair 
% 'PlotCoordinateFcn',@dumbbellPlotCoords to the above line of code 
% Phi = quantumGraph(...

plotCoordsCheb = dumbellPlotCoordsCheb(Phi);
Phi.addPlotCoords(plotCoordsCheb);
Phi.plot('layout')


%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes
% calculated as positive and sometimes as negative and this screws up the
% sorting.


[A,B] = GCrectangularCollocation(Phi);
[V,d] = eigQG(A,B,16);
lambda = diag(d);


[singles,doubles,~]=separateEigs(lambda); % No triple eigenvalue unless handle and hoops resonant
nToPlot=4;
letters='abcd';


%% Plot the first few multiplicity-one eigenfunctions
for k=1:nToPlot
    %%
    figure
    Phi.plot(V(:,singles(k)))
    title(sprintf('(%s) $\\lambda = %0.3f$', letters(k),lambda(singles(k))));
    %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',singles(k), lambda(singles(k))));
    if saveFlag
        fcnfile=['eigenfunction.1.' int2str(k)];
        filename=fullfile(outputDir,fcnfile);
        eigenfunction=V(:,singles(k));
        save(filename,'eigenfunction','-ascii')
        lambdafile=['lambda.1.' int2str(k)];
        filename=fullfile(outputDir,lambdafile);
        eigenvalue=lambda(singles(k));
        save(filename,'eigenvalue','-ascii')
    end
end


letters='ef';

%% Plot the first few multiplicity-two eigenfunctions
for k=1:nToPlot/2
    %%
    figure
    [v1,~]=dumbbellResolveDoubles(V,doubles(k));
    Phi.plot(v1)
    title(sprintf('(%s) $\\lambda = %0.3f$', letters(k), lambda(doubles(k))));
    %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',doubles(k), lambda(doubles(k))));
    if saveFlag
        fcnfile=['eigenfunction.2.' int2str(k)];
        filename=fullfile(outputDir,fcnfile);
        eigenfunction=v1;
        save(filename,'eigenfunction','-ascii')
        lambdafile=['lambda.2.' int2str(k)];
        filename=fullfile(outputDir,lambdafile);
        eigenvalue=lambda(singles(k));
        save(filename,'eigenvalue','-ascii')
    end    
end