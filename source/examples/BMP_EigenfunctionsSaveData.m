%% Berkolaiko-Marzuola-Pelinovsky Laplacian program
% Computes the eigenvalues and eigenfunctions of the Laplace operator
function BMP_EigenfunctionsSaveData

saveFlag=true;
if saveFlag
    datadir='data/BMP_Continuation';
    tag='BMP_Eigenfunctions';
    runNumber=incrementRunNumber(tag);
    outputDir=[datadir '/' tag get_label(runNumber)];
    mkdir(outputDir);
end

%% Set up the graph structure and coordinates of the problem
source=[1 1 1 1 2 3 4 5 6];
target=[1 2 3 4 2 5 6 2 2];
Ledge0 = 4*pi;
Ledge1 = Ledge0;
L=[2*pi, Ledge0, Ledge1/4, Ledge1/4, 2*pi, 2*Ledge1/4,  2*Ledge1/4, Ledge1/4, Ledge1/4];
NLoop = 64;
NEdge = 2*NLoop;
nx = [NLoop NEdge 1/4*NEdge 1/4*NEdge NLoop 1/2*NEdge 1/2*NEdge 1/4*NEdge 1/4*NEdge];
Phi = quantumGraph(source,target,L,'nxVec',nx);


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

Phi.addPlotCoords(@adde3l2v2PlotCoords);
Phi.plot('layout')

%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes
% calculated as positive and sometimes as negative and this screws up the
% sorting.
MBMP = Phi.laplacianMatrix;
[V,d]=eig(full(MBMP));
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

% letters='ef';
% % Plot the first few multiplicity-two eigenfunctions
% for k=1:nToPlot/2
%     %%
%     figure
%     [v1,~]=dumbbellResolveDoubles(V,doubles(k));
%     Phi.plot(v1)
%     title(sprintf('(%s) $\\lambda = %0.3f$', letters(k), lambda(doubles(k))));
%     %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',doubles(k), lambda(doubles(k))));
%     if saveFlag
%         fcnfile=['eigenfunction.2.' int2str(k)];
%         filename=fullfile(outputDir,fcnfile);
%         eigenfunction=v1;
%         save(filename,'eigenfunction','-ascii')
%         lambdafile=['lambda.2.' int2str(k)];
%         filename=fullfile(outputDir,lambdafile);
%         eigenvalue=lambda(singles(k));
%         save(filename,'eigenvalue','-ascii')
%     end    
% end