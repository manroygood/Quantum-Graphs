function ek = ek(G,node,k)
% Return a unit vector used in constructing various matrices and the
% secular determinant
    [~,nxC,nxTot] = G.nx;
    I = eye(nxTot);
    [~,inOrOut,adjacentEdges] = G.fullDegreeEtc(node);
    
    if inOrOut(k) == 1                       % If edge is incoming...
        ek = I(nxC(adjacentEdges(k)+1),:);       % ek is the last discretization point on the edge
    else                                     % If edges is outgoing...
        ek = I(nxC(adjacentEdges(k))+1,:);       % ek is the first discretization point on the edge
    end
    
end