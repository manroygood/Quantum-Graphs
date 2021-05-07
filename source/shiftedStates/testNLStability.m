function [G,U]=testNLStability(nEdges,L,nx,x0,p,M,mu,tfinal,dt,tplot,dPML,sigmaPML,pPML,gammaPML,verbose)

G=starQuantumGraph(nEdges,L,nx,nan,true);
G=addNStarPlotCoords(G);
G0=shiftedState(G,x0,0,p);
Gpert=perturbingFactor(G,M,mu);
mVec=ones(nEdges,1);mVec(1)=-1; % Weight vector, used for computing momentum only
G.Edges.m=mVec;

A=quantumGraphLaplacianPML(G,dPML,sigmaPML,pPML,gammaPML);

u0 = graph2column(G0).*graph2column(Gpert);

U=solveSplitStepHiOrder(A,p,u0,tfinal,dt);

if ~exist('verbose','var')
    verbose=false;
end

if verbose
figure(1);clf;
pcolor(abs(U));shading interp

figure(2);clf;
animateGraphSolution2D(U,G,dPML,dt,tplot)

figure(3);clf;
interpolateAndPlot(abs(U(:,1)),G)
hold on
interpolateAndPlot(abs(U(:,end)),G,'r')
end