function Phi=star(opts)

arguments
    opts.nbranches {mustBeNumeric,mustBePositive} = 3;
    opts.nLevels {mustBeNumeric,mustBePositive} = 4;
    opts.LVec  {mustBeNumeric,mustBePositive} = pi;
    opts.nX  {mustBeNumeric,mustBeInteger,mustBeNonnegative} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
    opts.weight {mustBeNumeric} = [];
    opts.stretch {mustBeNumeric,mustBeNonnegative}
end

assert(nbranches>2, 'must have three or more branches')

n=opts.n;
nOnes=ones(1,n);
if isempty(opts.weight); opts.weight=ones(n,1); end

if isscalar(opts.LVec)
    opts.LVec = opts.LVec(1)*nOnes;
end

assert( any(length(opts.nX)==[1 n]), 'nX must have length 1 or n')
assert( any(length(opts.LVec) == [1 n]), 'LVec must have length 1 or n')
assert( any(length(opts.robinCoeff) == [1 n+1]), 'robinCoeff must have length 1 or n+1')

source=nOnes;
target=2:(n+1);

if isfield(opts,'stretch')
Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization,'weight',opts.weight,'stretch',opts.stretch);
else
    Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization,'weight',opts.weight);
end