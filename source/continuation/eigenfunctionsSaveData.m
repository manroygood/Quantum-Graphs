function diagramNumber=eigenfunctionsSaveData(Phi,tag,nToPlot,nDoubles,nTriples)
%% EigenfunctionsSaveData
% Computes the eigenvalues and eigenfunctions of the Laplace operator
% Saves the data to files in the directory
% data/<tag>/getLabel(diagramNumber)
% If saving double or triple eigenvalues, need routines named
% <tag>ResolveDoubles.m
% <tag>ResolveTriples.m
% These take the arguments (V,k,Phi)

if ~exist('nToPlot','var'); nToPlot=4;end

close all
dataDir=fullfile('data',tag);
if ~exist(dataDir,'dir')
    mkdir(dataDir)
end
diagramNumber=incrementRunNumber(tag);
outputDir=fullfile(dataDir,getLabel(diagramNumber));
mkdir(outputDir);

%% Plot the graph layout
Phi.plot('layout')

%% Save the template to a file
filename=fullfile(outputDir,'template');
save(filename,'Phi');

%% Save a comment file
filename=fullfile(outputDir,'comment.txt');
fid=fopen(filename,'w');
fprintf(fid,'This directory contains:\n');

%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes
% calculated as positive and sometimes as negative and this screws up the
% sorting.
[V,lambda]=Phi.eigs(2*nToPlot+2*nDoubles+3*nTriples);
[singles,doubles,triples]=separateEigs(lambda); % No triple eigenvalue unless handle and hoops resonant

%% Plot and Save the first few multiplicity-one eigenfunctions
for j=1:nToPlot
    %%
    figure
    Phi.plot(V(:,singles(j)))
    title(sprintf('(%s) $\\lambda = %0.3f$', letter(j),lambda(singles(j))));
    %    title(sprintf('Eigenfunction %i, \\lambda = %0.3f',singles(k), lambda(singles(k))));
    fcnfile=['eigenfunction.' getLabel(j)];
    filename=fullfile(outputDir,fcnfile);
    eigenfunction=V(:,singles(j));
    save(filename,'eigenfunction','-ascii')
    lambdafile=['lambda.' getLabel(j)];
    filename=fullfile(outputDir,lambdafile);
    eigenvalue=lambda(singles(j));
    save(filename,'eigenvalue','-ascii')
    fprintf(fid,'lambda.%i: Multiplicity 1, eigenvalue = %0.3f\n',j, eigenvalue);
end

nn=nToPlot;
%% Plot and save the first few multiplicity-two eigenfunctions
if exist('nDoubles','var') && nDoubles>0 && ~isempty(doubles)
    resolveString=[tag 'ResolveDoubles'];
    assert(exist(resolveString,'file'),sprintf('The function %s does not exist.',resolveString))
    resolveDoubles=str2func(resolveString);
    for j=1:nDoubles
        for k=1:2
            %%
            vDouble=resolveDoubles(V,doubles(j),Phi);
            nn=nn+1;
            figure
            v1=vDouble{k};
            Phi.plot(v1)
            title(sprintf('(%s) $\\lambda = %0.3f$', letter(nn), lambda(doubles(j))));
            fcnfile=['eigenfunction.' getLabel(nn)];
            filename=fullfile(outputDir,fcnfile);
            save(filename,'v1','-ascii')
            lambdafile=['lambda.' getLabel(nn)];
            filename=fullfile(outputDir,lambdafile);
            eigenvalue=lambda(doubles(j));
            save(filename,'eigenvalue','-ascii')
            fprintf(fid,'lambda.%i: Multiplicity 2, eigenvalue = %0.3f\n',nn, eigenvalue);
        end
    end
end
%% Plot the first few multiplicity-three eigenfunctions
if exist('nTriples','var') && nTriples>0 && ~isempty(triples)
    resolveString=[tag 'ResolveTriples'];
    assert(exist(resolveString,'file'),sprintf('The function %s does not exist.',resolveString))
    resolveTriples=str2func(resolveString);
    for j=1:nTriples
        for k=1:3
            %%
            vTriple=resolveTriples(V,triples(j),Phi);
            nn=nn+1;
            figure
            v1=vTriple{k};
            Phi.plot(v1)
            title(sprintf('(%s) $\\lambda = %0.3f$', letter(nn), lambda(triples(j))));
            fcnfile=['eigenfunction.' getLabel(nn)];
            filename=fullfile(outputDir,fcnfile);
            save(filename,'v1','-ascii')
            lambdafile=['lambda.' getLabel(nn)];
            filename=fullfile(outputDir,lambdafile);
            eigenvalue=lambda(triples(j));
            save(filename,'eigenvalue','-ascii')
            fprintf(fid,'lambda.%i: Multiplicity 3, eigenvalue = %0.3f\n',nn, eigenvalue);
        end
    end
end
fclose(fid);
fprintf('Saved to directory %s.\n',outputDir)
fprintf('Run number is %i.\n',diagramNumber)