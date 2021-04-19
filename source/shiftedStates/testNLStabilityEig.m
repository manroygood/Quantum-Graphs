function [Phi,U]=testNLStabilityEig(nEdges,L,weighted,nx,x0,p,epsilon,tfinal,dt,tplot,dPML,sigmaPML,pPML,gammaPML,verbose)

Phi=starQuantumGraph(nEdges,L,nx,nan,weighted);
Phi=addNStarPlotCoords(Phi);
G0=shiftedState(Phi,x0,0,p);
%Gpert=perturbingEigenfunction(G,x0,p);
Gpert=nStarLPlusEigenfunctions(nEdges,p,x0,L,nx);
mVec=ones(nEdges,1);mVec(1)=-1; % Weight vector, used for computing momentum only
Phi.Edges.m=mVec;

A=quantumGraphLaplacianPML(Phi,dPML,sigmaPML,pPML,gammaPML);

u0 = graph2column(G0)+epsilon*graph2column(Gpert);

U=solveSplitStepHiOrder(A,p,u0,tfinal,dt);
% This was to fix a problem with spontaneous numerical symmetry-breaking
%U=solveSplitStepHiOrderSymmetric(A,p,u0,tfinal,dt);

if ~exist('verbose','var')
    verbose=false;
end

if verbose
figure(1);clf;
pcolor(abs(U));shading interp

figure(2);clf;
animateGraphSolution2D(U,Phi,dPML,dt,tplot)

figure(3);clf;
interpolateAndPlot(abs(U(:,1)),Phi)
hold on
interpolateAndPlot(abs(U(:,end)),Phi,'r')
end