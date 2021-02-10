%% Dumbbell Bifurcation Check
delete .dumbbellEigenfunctions_number
delete .DumbbellContinuation_number
rmdir data/DumbbellContinuation s

dumbbellEigenfunctionsSaveDataCheb
close all
dumbbellNonlinContFromEigCheb(1,1,1,0.1,1,-1,4,true,true);
continueFromBranchPointCheb('DumbbellContinuation',1,6,-1,3,.1,1,1);   % ds = .01 in graphNonlinearContCheb
% continueFromBranchPointCheb('DumbbellContinuation',1,12,1,5,.1,1);     % ds = .005
% continueFromBranchPointCheb('DumbbellContinuation',1,12,-1,3,1,1);     % ds = .005
% continueFromBranchPointCheb('DumbbellContinuation',6,26,-1,3,.1,1);  % ds = .01
quickBifurcationDiagram

%% Dumbbell Bifurcation - Finite difference
delete .dumbbellEigenfunctions_number
delete .DumbbellContinuationFinite_number
rmdir data/DumbbellContinuationFinite s

dumbbellEigenfunctionsSaveData
close all
dumbbellNonlinContFromEig(1,1,1,0.1,1,-1,4,true,true);
continueFromBranchPoint('DumbbellContinuationFinite',1,6,-1,3,.1,1,1);




%% Line Bifurcation Check
delete .lineEigenfunctions_number
delete .LineContinuation_number
rmdir data/LineContinuation s

lineEigenfunctionsSaveDataCheb
close all
lineNonlinContFromEigCheb(1,1,1,0.1,1,-5,4,true,true);
% continueFromBranchPointCheb('LineContinuation',1,6,-1,3,.1,1,1);   % ds = .01 in graphNonlinearContCheb
% continueFromBranchPointCheb('DumbbellContinuation',1,12,1,5,.1,1);     % ds = .005
% continueFromBranchPointCheb('DumbbellContinuation',1,12,-1,3,1,1);     % ds = .005
% continueFromBranchPointCheb('DumbbellContinuation',6,26,-1,3,.1,1);  % ds = .01
% quickBifurcationDiagram

%% Line Bifurcation - Finite difference
delete .lineEigenfunctions_number
delete .LineContinuationFinite_number
rmdir data/LineContinuationFinite s

lineEigenfunctionsSaveData
close all
lineNonlinContFromEig(1,1,1,0.1,1,-1,4,true,true);

%% Plot Dumbbell Eigenfunctions at Bifurcation Points
LVec=[2*pi,4,2*pi];
n=32; nX=[n n n];
robinCoeff = [0 0];
Gcheb = quantumGraph([1 1 2],[1 2 2],LVec,'nxVec',nX,'RobinCoeff',robinCoeff);
plotCoordsCheb = dumbellPlotCoordsCheb(Gcheb);
Gcheb.addPlotCoords(plotCoordsCheb);
Gcheb.plot('layout')

v1 = importdata('data/DumbbellContinuation/002/PhiColumn.10');
v2 = importdata('data/DumbbellContinuation/002/PhiColumn.15');
figure
Gcheb.plot(v1)

figure
Gcheb.plot(v2)



%% Spectrum of the JL operator on a line
Phi = lineGraph(2,0,0);

[A,B] = Phi.GCrectangularCollocation;
M = Phi.laplacianMatrix;

N = length(A);

PhiCol1 = importdata('data/LineContinuation/001/PhiColumn.65');
muVec1 = importdata('data/LineContinuation/001/LambdaVec');
mu01 = muVec1(65);
funcs = getGraphFcnsCheb(A,B);
Bjl = [B zeros(N); zeros(N) B];
JL = @(z,mu) funcs.fullLinearization(z,mu);
[evecsJLcheb,evalsJLcheb] = eigJL(full(JL(PhiCol1,mu01)),Bjl);
eCheb = diag(evalsJLcheb); eCheb = diag(eCheb);

PhiCol2 = importdata('data/LineContinuationFinite/003/PhiColumn.65');
muVec2 = importdata('data/LineContinuationFinite/003/LambdaVec');
mu02 = muVec2(65);
funcs = getGraphFcns(M);
JL = @(z,mu) funcs.fullLinearization(z,mu);
[evecsJLfin,evalsJLfin] = eig(full(JL(PhiCol2,mu02)));
eFin = diag(evalsJLfin);

figure
plot(evecsJLcheb(1:32,63))

figure
plot(evecsJLcheb(33:64,63))

figure
x = real(eCheb);
y = imag(eCheb);
plot(x,y,'o')
hold on
xFin = real(eFin);
yFin = imag(eFin);
plot(xFin,yFin,'x')
xlim([-10^(-5),10^(-5)]);
ylim([-50,50]);



%% Spectrum of the JL operator on Dumbbell
LVec = [2*pi,4, 2*pi];
n = 32; nX = [n n n];
robinCoeff = [0 0];
Phi = quantumGraph([1 1 2],[1 2 2],LVec,'nxVec',nX,'RobinCoeff',robinCoeff);

[A,B] = Phi.GCrectangularCollocation;
M = Phi.laplacianMatrix;

N = length(A);

PhiCol1 = importdata('data/DumbbellContinuation/002/PhiColumn.19'); % Can also try 47
muVec1 = importdata('data/DumbbellContinuation/002/LambdaVec');
mu01 = muVec1(19);
funcs = getGraphFcnsCheb(A,B);
Bjl = [B zeros(N); zeros(N) B];
JL = @(z,mu) funcs.fullLinearization(z,mu);
[evecsJLcheb,evalsJLcheb] = eigJL(full(JL(PhiCol1,mu01)),Bjl);
eCheb = diag(evalsJLcheb); eCheb = diag(eCheb);

PhiCol2 = importdata('data/DumbbellContinuationFinite/002/PhiColumn.17'); % vs 46
muVec2 = importdata('data/DumbbellContinuationFinite/002/LambdaVec');
mu02 = muVec2(17);
funcs = getGraphFcns(M);
JL = @(z,mu) funcs.fullLinearization(z,mu);
[evecsJLfin,evalsJLfin] = eig(full(JL(PhiCol2,mu02)));
eFin = diag(evalsJLfin);

figure
x = real(eCheb);
y = imag(eCheb);
plot(x,y,'o')
hold on
xFin = real(eFin);
yFin = imag(eFin);
plot(xFin,yFin,'x')
xlim([-10^(-5),10^(-5)]);
ylim([-10,10]);
