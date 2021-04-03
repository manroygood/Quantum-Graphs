function Phi=tribell(opts)

arguments
    opts.LVec  {mustBeNumeric} = [2 2 2 2*pi 2*pi 2*pi];
    opts.nX  {mustBeNumeric} = 10;
    opts.robinCoeff {mustBeNumeric} = 0;
end

% If LVec has length 2, then 1st argument -> handle and 2nd argument ->
% hoop
if length(opts.LVec) == 2
    opts.LVec = [opts.LVec(1)*[1 1 1] opts.LVec(2)*[1 1 1]];
end

% If nx has length 2, then 1st argument -> handle and 2nd argument -> hoop
if length(opts.nX) == 2
    opts.nX = [opts.nX(1)*[1 1 1] opts.nX(2)*[1 1 1]];
end

assert( any(length(opts.nX)==[1 2 3]), 'nX must have length 1, 2, or 6')
assert( any(length(opts.LVec) == [2 3]), 'LVec must have length  2 or 6')
assert( any(length(opts.robinCoeff) == [1 3]), 'robinCoeff must have length 1 or 6')

source=[1 1 1 2 3 4];
target=[2 3 4 2 3 4];

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff);