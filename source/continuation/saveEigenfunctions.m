function saveEigenfunctions(Phi,tag,dataDir,nToPlot,nDoubles,nTriples,verbose)
%% EigenfunctionsSaveData
% Computes the eigenvalues and eigenfunctions of the Laplace operator
% Saves the data to files in the directory
% data/<tag>/getLabel(diagramNumber)
% If saving double or triple eigenvalues, need routines named
% <tag>ResolveDoubles.m
% <tag>ResolveTriples.m
% These take the arguments (V,k,Phi)

if ~exist('nToPlot','var'); nToPlot=4;end
if ~exist('nDoubles','var'); nDoubles=0;end
if ~exist('nTriples','var'); nTriples=0;end
if ~exist('verbose','var'); verbose = false; end

addComment(dataDir,"This directory contains eigenfunctions:")

%% Construct the Laplacian and calculate its eigenvalues and eigenvectors
% A little cleanup needed because the null eigenvalue is sometimes
% calculated as positive and sometimes as negative and this screws up the
% sorting.
numEigs= 2*nToPlot+2*nDoubles+3*nTriples;
[V,lambda]=Phi.eigs(numEigs);
[singles,doubles,triples]=separateEigs(lambda);

%% Plot and Save the first few multiplicity-one eigenfunctions
for j=1:nToPlot
    %%
    if verbose
        figure
        Phi.plot(V(:,singles(j)))
        title(sprintf('(%s) $\\lambda = %0.3f$', letter(j),lambda(singles(j))));
    end
    fcnfile=['eigenfunction.' getLabel(j)];
    filename=fullfile(dataDir,fcnfile);
    eigenfunction=V(:,singles(j));
    save(filename,'eigenfunction','-ascii')
    lambdafile=['lambda.' getLabel(j)];
    filename=fullfile(dataDir,lambdafile);
    eigenvalue=lambda(singles(j));
    save(filename,'eigenvalue','-ascii')
    addComment(dataDir,'lambda.%i: Multiplicity 1, eigenvalue = %0.3f',j, eigenvalue)
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
            v1=vDouble{k};
            if verbose
                figure
                Phi.plot(v1)
                title(sprintf('(%s) $\\lambda = %0.3f$', letter(nn), lambda(doubles(j))));
            end
            fcnfile=['eigenfunction.' getLabel(nn)];
            filename=fullfile(dataDir,fcnfile);
            save(filename,'v1','-ascii')
            lambdafile=['lambda.' getLabel(nn)];
            filename=fullfile(dataDir,lambdafile);
            eigenvalue=lambda(doubles(j));
            save(filename,'eigenvalue','-ascii')
            addComment(dataDir,'lambda.%i: Multiplicity 2, eigenvalue = %0.3f',nn, eigenvalue);
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
            v1=vTriple{k};
            if verbose
                figure
                Phi.plot(v1)
                title(sprintf('(%s) $\\lambda = %0.3f$', letter(nn), lambda(triples(j))));
            end
            fcnfile=['eigenfunction.' getLabel(nn)];
            filename=fullfile(dataDir,fcnfile);
            save(filename,'v1','-ascii')
            lambdafile=['lambda.' getLabel(nn)];
            filename=fullfile(dataDir,lambdafile);
            eigenvalue=lambda(triples(j));
            save(filename,'eigenvalue','-ascii')
            addComment(dataDir,'lambda.%i: Multiplicity 3, eigenvalue = %0.3f',nn, eigenvalue);
        end
    end
end
addComment(dataDir);