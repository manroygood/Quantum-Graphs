function interpAtNodes(G)
% Interpolates the Edges.y field of a quantum graph G to the Nodes.y field

nNodes=numnodes(G);
yNodes=zeros(nNodes,1);

for k = 1:nNodes
    [~,inOrOut,allEdges]=fullDegreeEtc(G,k);
    edge=allEdges(1);
    y=G.y{edge};
    if  inOrOut(1)==1
        yNodes(k) = (y(end)+y(end-1))/2;
    else
        yNodes(k) = ( y(1)+y(2))/2;
    end
end

G.qg.Nodes.y=yNodes;

end