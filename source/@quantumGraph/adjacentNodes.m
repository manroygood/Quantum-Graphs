function [n1,n2] = adjacentNodes(G,j)
    % Finds the two nodes that are adjacent to edge j in graph G
    
    n1 = G.EndNodes(j,1);
    n2 = G.EndNodes(j,2);
    
end