function PhiX=extendPeriodic(PhiX,Phi,extensionMap)
% Uses the vectors in extensionMap to extend the y-data in the periodic
% graph Phi to the extended map PhiX

for k=1:PhiX.numedges
    PhiX.qg.Edges.y{k}= Phi.qg.Edges.y{extensionMap.edges(k)};
end

PhiX.qg.Nodes.y= Phi.qg.Nodes.y(extensionMap.nodes);