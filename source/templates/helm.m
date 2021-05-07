function Phi=helm(opts)
% Optional input arguments
% n = number of sides of the wheel
% nX = number of points per unit length, must be scalar
% r = vector of two lengths: radius of the wheel & length of handle
% robinCoeff = the Robin Coeff. If scalar, then same coeff at each node
%                               If length (n+1), then node-by-node

arguments
    opts.n {mustBeNumeric} = 6;
    opts.nX  {mustBeNumeric} = 20;
    opts.r {mustBeNumeric} = pi*[1 1];
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
end

n=opts.n;
r=opts.r;

nOnes=ones(1,n);

% Error checking
assert( length(opts.nX)== 1, 'nX must be scalar')
assert( length(opts.r)== 2, 'r must be length 2')
assert( any(length(opts.robinCoeff) == [1 n+1]), 'robinCoeff must have length 1 or n+1');

source = zeros(1,3*n);
target = zeros(1,3*n);
LVec = zeros(1,3*n);

source(1:n) = nOnes;
target(1:n) = 2:n+1;
LVec(1:n) = r(1)*nOnes;

for k=1:n
    source(n+2*k-1) = k+1;
    target(n+2*k-1) = k+2;
    LVec(n+2*k-1) = 2*r(1)*sin(pi/n);
    source(n+2*k) = k+1;
    target(n+2*k) = n+k+1;
    LVec(n+2*k) = r(2);
end
target(3*n-1) = 2; % Fix one 

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization);