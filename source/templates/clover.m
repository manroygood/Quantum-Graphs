function Phi=clover(opts)

arguments
    opts.LVec  {mustBeNumeric} = pi;
    opts.nLeaves {mustBeNumeric} = 4;
    opts.nX  {mustBeNumeric} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end

assert(any(length(opts.LVec)==[1 opts.nLeaves]),...
    'The length vector must match the number of leaves or be scalar')
assert(any(length(opts.nX)==[1 opts.nLeaves]),...
    'The nX vector must match the number of leaves or be scalar')

% If LVec has length 2, then 1st argument -> handle and 2nd argument ->
% hoop
nOnes=ones(1,opts.nLeaves);
if isscalar(opts.LVec)
    opts.LVec = opts.LVec*nOnes;
end

% If nx has length 2, then 1st argument -> handle and 2nd argument -> hoop
if isscalar(opts.nX) 
    opts.nX = opts.nX*nOnes;
end

source=nOnes;
target=nOnes;

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization);