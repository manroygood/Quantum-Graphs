function Phi=wheel(opts)
% Optional input arguments
% n = number of sides of the wheel
% nX = number of points per unit length, must be scalar
% r = radius of the wheel
% robinCoeff = the Robin Coeff. If scalar, then same coeff at each node
%                               If length (n+1), then node-by-node

arguments
    opts.n {mustBeNumeric} = 6;
    opts.nX  {mustBeNumeric} = 20;
    opts.r {mustBeNumeric} = pi;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
end

n=opts.n;
r=opts.r;

nOnes=ones(1,n);
LVec=[r*nOnes 2*r*sin(pi/n)*nOnes];

% Error checking
assert( length(opts.nX)== 1, 'nX must be scalar')
assert( length(opts.r)== 1, 'r must be scalar')
assert( any(length(opts.robinCoeff) == [1 n+1]), 'robinCoeff must have length 1 or n+1');

source=[nOnes 2:n+1];
target=[2:n+1 3:n+1 2];

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,...
      'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);