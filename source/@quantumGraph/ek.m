function ek = ek(G,node,k)
    [~,nxC,nxTot] = G.nx;
    I = eye(nxTot);
    [~,inOrOut,adjacentEdges] = G.fullDegreeEtc(node);
    
    if inOrOut == 1                       % If edge is incoming...
        ek = I(nxC(adjacentEdges(k)+1),:);          % ek gives us the last disc point on the edge
    else                                        % If edges is outgoing...
        ek = I(nxC(adjacentEdges(k))+1,:);          % ek gives us the first disc point on the edge
    end
    
end