function Phi=necklace(opts)

arguments
    opts.LString {mustBeNumeric} = 1; % This is the length of the connection between two pearls
    opts.LPearl {mustBeNumeric} = pi; % This is half the circumference of the circular part
    opts.nPearls {mustBeNumeric} = 4;
    opts.nX  {mustBeNumeric} = 20;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end

nPearls=opts.nPearls;
LString = opts.LString;
LPearl = opts.LPearl;
LVec=LPearl*ones(3*nPearls,1);
LVec(3:3:end)=LString;

source =zeros(3*nPearls,1);
target = source;

source(1:3:3*nPearls)=1:2:2*nPearls;
source(2:3:3*nPearls)=1:2:2*nPearls;
source(3:3:3*nPearls)=2:2:2*nPearls;

target(1:3:3*nPearls)=2:2:2*nPearls;
target(2:3:3*nPearls)=2:2:2*nPearls;
target(3:3:3*nPearls)=mod(3:2:2*nPearls+2,2*nPearls);

Phi = quantumGraph(source, target,LVec,'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
      'Discretization',opts.Discretization);