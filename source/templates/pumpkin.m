function Phi=pumpkin(opts)

arguments
    opts.LVec  {mustBeNumeric} = pi;
    opts.numEdges {mustBeNumeric} = 3;
    opts.nX  {mustBeNumeric} = 32;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end

assert(any(length(opts.LVec)==[1 opts.numEdges]),...
    'The length vector must match the number of leaves or be scalar')
assert(any(length(opts.nX)==[1 opts.numEdges]),...
    'The nX vector must match the number of leaves or be scalar')

source=ones(opts.numEdges,1);
target = 2*source;

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization);