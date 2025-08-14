function Phi=balalaika(opts)

arguments
    opts.LVec  {mustBeNumeric,mustBePositive} = pi;
    opts.nX  {mustBeNumeric,mustBeInteger,mustBeNonnegative} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
    opts.weight {mustBeNumeric} = [];
end

n=4;
nOnes=ones(1,n);
if isempty(opts.weight); opts.weight=ones(n,1); end

if isscalar(opts.LVec)
    opts.LVec = opts.LVec(1)*nOnes;
end

assert( any(length(opts.nX)==[1 n]), 'nX must have length 1 or n')
assert( any(length(opts.LVec) == [1 n]), 'LVec must have length 1 or n')
assert( any(length(opts.robinCoeff) == [1 n+1]), 'robinCoeff must have length 1 or n+1')
assert( testTriangle(opts.LVec), 'The first three edge lengths must form a triangle')

source=[1 2 3 3];
target=[2 3 1 4];


Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
    'Discretization',opts.Discretization,'weight',opts.weight);
end

function flag= testTriangle(L)

if L(1)+L(2)>L(3) && L(2)+L(3)>L(1) && L(3)+L(1)> L(2)
    flag=true;
else
    flag=false;
end

end