function ek = ek(G,node,k)
% Given a node (node) and kth edge affiliated with node, ek returns the standard
% basis vector coresponding to the discretization point of edge k based on
% it's orientation with respect to node.
    [~,nxC,nxTot] = G.nx;
    I = eye(nxTot);
    [~,inOrOut,adjacentEdges] = G.fullDegreeEtc(node);
    
    if inOrOut(k) == 1                          % If edge is incoming...
        ek = I(nxC(adjacentEdges(k)+1),:);          % ek gives us the last disc point on the edge
    else                                        % If edges is outgoing...
        ek = I(nxC(adjacentEdges(k))+1,:);          % ek gives us the first disc point on the edge
    end
    
end