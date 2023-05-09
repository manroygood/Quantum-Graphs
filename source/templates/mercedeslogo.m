function Phi=mercedeslogo(opts)
% Really just a tetrahedron but flattened to lie on the plane, with three
% circular-arc edges.
% This program exists to test the program circularArcEdge.m

arguments
    opts.nX  {mustBeNumeric} = 10;
    opts.L {mustBeNumeric} = 8;
    opts.robinCoeff {mustBeNumeric} = 0;
    opts.Discretization {mustBeNonzeroLengthText, mustBeMember(opts.Discretization,{'Uniform','Chebyshev','None'})} = 'Uniform';
end
assert( length(opts.nX)== 1, 'nX must be scalar')
assert( any(length(opts.robinCoeff) == [1 4]), 'robinCoeff must have length 1 or 4');

source = [1 1 1 2 3 4];
target = [2 3 4 3 4 2];

Phi = quantumGraph(source, target,opts.L,'nxVec',opts.nX,...
    'robinCoeff',opts.robinCoeff,'Discretization',opts.Discretization);