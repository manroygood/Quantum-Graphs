function Phi=multibell(opts)

% This is a generalization of the dumbbell graph to multiple "bells"

% nBells = 1 returns the lollipop
% nBells = 2 returns the dumbbell
% nBells >= 3 returns the multibell, which consists of lollipops joined at
%             the "bottoms of the sticks"

arguments
    opts.LVec  {mustBeNumeric} = [2 pi];
    opts.nBells {mustBeNumeric} = 3;
    opts.nX  {mustBeNumeric} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
end

assert(mod(length(opts.LVec),2)==0,'The length vector must have an even number of elements')

% If LVec has length 2, then 1st argument -> handle and 2nd argument ->
% hoop
nOnes=ones(1,opts.nBells);
if length(opts.LVec) == 2
    opts.LVec = [opts.LVec(1)*nOnes opts.LVec(2)*nOnes];
end
n=length(opts.LVec)/2;

assert(any(length(opts.nX)==[1 2 2*n]),'nX must have length 1, 2  or 2n');

% If nx has length 2, then 1st argument -> handle and 2nd argument -> hoop
if length(opts.nX) == 2
    opts.nX = [opts.nX(1)*nOnes opts.nX(2)*nOnes];
end

assert( any(length(opts.robinCoeff) == [1 n+1]), 'robinCoeff must have length 1 or n+1')

nOnes=ones(1,n);nPlus=2:n+1;
source=[nOnes nPlus];
target=[nPlus nPlus];

Phi = quantumGraph(source, target,opts.LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization);