function G=starQuantumGraph(nEdges,L,nx,robinCoeff,weightFlag)
% creates a star shaped graph with nEdges edges

% Kairzhan & Pelinovsky define weights to allow for momentum conservation
% at the central vertex, with the first (incoming) edge assigned a weight of
% (nEdges-1) and the remaining (outgoing) edges assigned a weight of one
% if weightFlag is true, then set the K&P weights. Else, all weights set to
% one
if ~exist('weightFlag','var')
    weightFlag=false;
end

weights=ones(nEdges,1);
if weightFlag
    weights(1)=nEdges-1; 
end

% if robinCoeff is a scalar NAN, then set Kirchhoff at central vertex,
% dirichlet at leaf vertices
if ~isempty(robinCoeff) && (length(robinCoeff)==1 && isnan(robinCoeff))
    robinCoeff=nan(nEdges+1,1);
    robinCoeff(1)=0;
end

sources=ones(1,nEdges);
targets=1+(1:nEdges);
G=quantumGraph(sources,targets,L,nx,robinCoeff,weights);