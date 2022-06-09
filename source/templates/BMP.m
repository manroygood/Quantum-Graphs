function Phi=BMP(opts)

arguments
    opts.LVec  {mustBeNumeric} = [2 pi pi pi 2];
    opts.nX  {mustBeNumeric} = 10;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
end

assert( any(length(opts.nX)==[1 2 5]), 'nX must have length 1, 2, or 5')
assert( any(length(opts.LVec) == [2 5]), 'LVec must have length  2 or 5')
assert( any(length(opts.robinCoeff) == [1 5]), 'robinCoeff must have length 1 or 5')

% If LVec has length 2, then 1st argument -> end hoops and 2nd argument ->
% three interior handles
if length(opts.LVec) == 2
    opts.LVec = [opts.LVec(1) opts.LVec(2) opts.LVec(2) opts.LVec(2) opts.LVec(1)];
end

% If LVec has length 2, then 1st argument -> end hoops and 2nd argument ->
% three interior handles
if length(opts.nX) == 2
    opts.nX = [opts.nX(1) opts.nX(2) opts.nX(2) opts.nX(2) opts.nX(1)];
end

source=[1 1 1 1 2];
target=[1 2 2 2 2];

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff);