function node = GCsharedNode(G,j,jprime)
    % Finds the node that is adjacent to both edge_j and edge_jprime in graph G
    
    n=numedges(G);
    
    if G.follows(j,jprime)==true
        if j<=n
            node = G.EndNodes(j,2);
        else
            node = G.EndNodes(j-n,1);
        end
    else
        disp('edge_j and edge_jprime are not adjacent to eachother')
    end
    
end