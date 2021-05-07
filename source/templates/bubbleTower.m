function Phi=bubbleTower(opts)

arguments
    opts.L (1,1) {mustBeNumeric} = 10;  % The component of the real line
    opts.rVec (1,:) {mustBeNumeric} = [2 1]; % note that these are the radii of the bubbles, not their lengths
    opts.nX  {mustBeNumeric} = 10;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev'})} = 'Uniform';
end

rVec=opts.rVec;
n=length(rVec);

assert( any(length(opts.nX)==[1 2*n+1]), 'nX must have length 1 or 2n+1')
assert( any(length(opts.robinCoeff) == [1 n+2]), 'robinCoeff must have length 1 or n+2')

source = zeros(1, n+2);
target = source;
LVec = source;

source(1:4) = 1;
target(1:4) = [2 3 4 4];
LVec(1:2) = opts.L;
LVec(3:4) = pi*rVec(1);
for k=2:n-1
    source(2*k+1:2*k+2)=k+2;
    target(2*k+1:2*k+2)=k+3;
    LVec(2*k+1:2*k+2)=pi*rVec(k);
end
source(2*n+1)=n+2;
target(2*n+1)=n+2;
LVec(2*n+1)= 2*pi*rVec(n);

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,...
    'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);