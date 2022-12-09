function solution = solvePoisson(G,opts)
% Creates a right-hand side vector from vectors of data on the edges and
% nodes. If scalar, convert to a vector. If empty, set to zero.

arguments
   G % no tests, no default
   opts.edgeData {mustBeNumeric, mustBeVector} = 0
end

[~,~,nxTot]=G.nx;

if isscalar(opts.edgeData) 
    opts.edgeData = opts.edgeData * ones(nxTot,1);
end

% Some error checking

assert(length(opts.edgeData)==nxTot,'quantumGraph:edgeDataLengthIncompatible',...
    'Length of the edge data vector incompatible with the graph');

% The actual function

rhs=(G.interpolationMatrixWithZeros) * opts.edgeData + ...
        (G.nonhomogenousVCMatrix) * G.nodeData;
    
solution = G.laplacianMatrixWithVC \ rhs;