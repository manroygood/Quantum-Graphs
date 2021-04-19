function Phi=dumbbell(opts)

arguments
    opts.LVec {mustBeNumeric} = [2*pi 4 2*pi];
    opts.nX  {mustBeNumeric} = 10;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
end

% If LVec has length 2, then 1st argument -> hoop and 2nd argument -> handle
if length(opts.LVec) == 2
    opts.LVec = [opts.LVec(1) opts.LVec(2) opts.LVec(1)];
end

% If nx has length 2, then 1st argument -> hoop and 2nd argument -> handle
if length(opts.nX) == 2
    opts.nX = [opts.nX(1) opts.nX(2) opts.nX(1)];
end

assert( any(length(opts.nX)==[1 2 3]), 'nX must have length 1, 2, or 3')
assert( any(length(opts.LVec) == [2 3]), 'LVec must have length  2 or 3')
assert( any(length(opts.robinCoeff) == [1 2]), 'robinCoeff must have length 1 or 2')

source=[1 1 2];
target = [1 2 2];

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);