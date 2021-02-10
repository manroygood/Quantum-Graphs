%% Dumbbell Continuation program
% Computes the non-constant symmetric branch of the dumbbell graph
function [NVec,LambdaVec,bifTypeVec] = ...
    dumbbellNonlinContCheb(approach, beta,maxTheta,L,nX,Lambda0,saveFlag,plotFlag)

if ~exist('saveFlag','var')||isempty(saveFlag); saveFlag=false; end
if ~exist('plotFlag','var')||isempty(plotFlag); plotFlag=true;  end

%% Set up the graph structure and coordinates of the problem
Phi = quantumGraph([1 1 2],[1 2 2],L,'nxVec',nX);
Phi.addDependentCoords(1);

%% Set up the output directory and save the template
if saveFlag
    tag='DumbbellContinuation';
    outputDir=makeOutputDirectory(tag);
    filename=fullfile(outputDir,'template');
    save(filename,'Phi');
end

%% Set up coordinates on which to plot the solutions
plotcoords = dumbbellPlotCoordsCheb;
Phi.addPlotCoords(plotcoords);

%% Construct the Laplacian
M =  Phi.GCrectangularCollocation;
Phi = initPhiDumbbellNL(Phi,Lambda0,approach);
PhiColumn = graph2column(Phi);
direction=1; % assume we are initially looking for decreasing L^2 norm along the branch

fcns=getGraphFcnsCheb(M);

% The first solution on the branch
myF=@(z) fcns.f(z,Lambda0);
myMatrix = @(u) fcns.fLinMatrix(u,Lambda0);
figure(1);clf;hold on

initTol=1e-6;
[PhiColumn,~,~]=solveNewton(PhiColumn,myF,myMatrix,initTol);
LambdaThresh=1.01*Lambda0;
Phi.column2graph(PhiColumn);
NThresh=10*Phi.Norm;
[NVec,LambdaVec,bifTypeVec]=graphNonlinearContCheb(Phi,fcns,outputDir,PhiColumn,Lambda0,LambdaThresh,NThresh,beta,maxTheta,direction,saveFlag,plotFlag);