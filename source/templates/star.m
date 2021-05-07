function Phi=star(opts)

arguments
    opts.n {mustBeNumeric} = 3;
    opts.LVec  {mustBeNumeric} = pi;
    opts.nX  {mustBeNumeric} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
    opts.weight {mustBeNumeric} = [];
end

n=opts.n;
nOnes=ones(1,n);
if isempty(opts.weight); opts.weight=ones(n,1); end

% If LVec has length 2, then 1st argument -> handle and 2nd argument ->
% hoop
if length(opts.LVec) == 1
    opts.LVec = opts.LVec(1)*nOnes;
end

assert( any(length(opts.nX)==[1 n]), 'nX must have length 1 or n')
assert( any(length(opts.LVec) == [1 n]), 'LVec must have length 1 or n')
assert( any(length(opts.robinCoeff) == [1 n+1]), 'robinCoeff must have length 1 or n+1')

source=nOnes;
target=2:(n+1);

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization,'weight',opts.weight);