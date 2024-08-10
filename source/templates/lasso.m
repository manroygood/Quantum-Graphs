function Phi=lasso(opts)

arguments
    opts.LVec  {mustBeNumeric} = [2*pi 2];
    opts.nX  {mustBeNumeric} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end

assert(any(length(opts.nX)==[1 2]),'nX must have length 1 or 2');

assert( any(length(opts.robinCoeff) == [1 2]), 'robinCoeff must have length 1 or 2')

source=[1 1];
target=[1 2];

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization);