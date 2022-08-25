function Phi=sunlet(opts)

arguments
    opts.n {mustBeNumeric} = 6;
    opts.LVec  {mustBeNumeric} = [pi pi];
    opts.nX  {mustBeNumeric} = 10;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end

n=opts.n;

% If LVec has length 2, then 1st argument -> handle and 2nd argument ->
% hoop
if length(opts.LVec) == 2
    LVec= zeros(2*n,1);
    LVec(1:2:end) = opts.LVec(1);
    LVec(2:2:end) = opts.LVec(2);
end

% If nx has length 2, then 1st argument -> handle and 2nd argument -> hoop
if length(opts.nX) == 2
    nX = zeros(2*n,1);
    nX(1:2:end) = opts.nX(1);
    nX(2:2:end) = opts.nX(2);
else
    nX=opts.nX;
end

assert( any(length(nX)==[1 2 2*n]), 'nX must have length 1, 2, or 6')
assert( any(length(LVec) == [2 2*n]), 'LVec must have length  2 or 6')
assert( any(length(opts.robinCoeff) == [1 n]), 'robinCoeff must have length 1 or 6')

source = zeros(2*n,1);
source(1:2:end) = (1:n)';
source(2:2:end) = (1:n)';
target = zeros(2*n,1);
target(1:2:end) = [(2:n)';1];
target(2:2:end) = (n+1:2*n)';

Phi = quantumGraph(source, target,LVec,'nxVec',nX,'robinCoeff',opts.robinCoeff,...
    'Discretization',opts.Discretization);