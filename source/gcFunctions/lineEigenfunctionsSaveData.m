%% Dumbbell Laplacian program
% Computes the eigenvalues and eigenfunctions of the Laplace operator
function lineEigenfunctionsSaveData

saveFlag=true;
if saveFlag
    datadir='data/LineContinuationFinite';
    tag='lineEigenfunctions';
    runNumber=incrementRunNumber(tag);
    outputDir=[datadir '/' tag get_label(runNumber)];
    mkdir(outputDir);
end

%% Set up the graph structure and coordinates of the problem
Phi = lineGraph(2,0,0); %Nuemann BC's

if saveFlag
    filename=fullfile(outputDir,'template');
    save(filename,'Phi');
end

%% Calculate and plot the secular determinant of the quantum graph
f = secularDet(Phi);
fplot(f,[0 4])

%% Set up coordinates on which to plot the solutions
% Note that the user has to create the plotting function
% Note further, you could also add this by adding the key-value pair 
% 'PlotCoordinateFcn',@dumbbellPlotCoords to the above line of code 
% Phi = quantumGraph(...

plotcoords = linePlotCoords(Phi);
Phi.addPlotCoords(plotcoords);
Phi.plot('layout')

%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes
% calculated as positive and sometimes as negative and this screws up the
% sorting.
Mline = Phi.laplacianMatrix;
[V,d]=eig(full(Mline));
d=diag(d); d=-abs(d); % The aforementioned cleanup
[lambda,ord]=sort(d,'descend');
lambda=abs(lambda);
V=real(V(:,ord));V(:,1)=abs(V(:,1));

[singles,doubles,~]=separateEigs(lambda); % No triple eigenvalue unless handle and hoops resonant
nToPlot=4;
letters='acbd';
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
if ~isempty(doubles)
    for k=1:nToPlot/2
        %%
        figure
        [v1,~]=dumbbellResolveDoubles(V,doubles(k));
        Phi.plot(v1)
        title(sprintf('(%s) $\\lambda = %0.3f$', letters(k), lambda(doubles(k))));
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
end

end