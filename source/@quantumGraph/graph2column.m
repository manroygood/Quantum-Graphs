function col = graph2column(G)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

[~,nxC,nxT]=G.nx;
col=zeros(nxT,1);

if G.isUniform
    
    for k=1:numedges(G)
        col(nxC(k)+1:nxC(k+1)) = G.Edges.y{k}(:);
    end
    
else
    
    for k=1:numedges(G)
        [n1,n2] = G.adjacentNodes(k);
        col(nxC(k)+1) = G.Nodes.y(n1);
        col(nxC(k+1)) = G.Nodes.y(n2);
        col(nxC(k)+2:nxC(k+1)-1) = G.Edges.y{k}(:);
    end
    
end