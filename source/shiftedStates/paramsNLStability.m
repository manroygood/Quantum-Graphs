%% Essentially the datafile for logNLStability.m

nEdges = 3;
L = 12;

% Discretization 
nx = 1200;

% Solitary wave position (x0=-a where a the position in the JPhysA paper)
x0 = 0;

% nonlinearity strength (total nonlinearity = 2p+1, so p=1 for cubic)
p = 1;

% parameters describing momentum-conservation-breaking perturbation
% created by program |perturbingState.m|
M = 2; % M-1 = number of perturbed outgoing directions, need 1 <= M < N
mu = .02*(-1i); % This is the exponential growth/decay rate factor on the outgoing edge

% simulation final time and discretization
tfinal = 129;
dt = 0.01;
tplot = .2;

% Parameters defining the Perfectly Matched Layer
pPML=4;
gammaPML=pi/4;
dPML=2;
sigmaPML=10;

% A comment to be included in the table of runs
comment = 'Redoing the simulation in 060 with better time resolution for publication.';
