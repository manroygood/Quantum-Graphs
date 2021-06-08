function column2graph(G,col)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

[~,nxC,~] = G.nx;
% assert(length(col) == nxTot,'Column and template not compatible.')

for k=1:numedges(G)
    G.qg.Edges.y{k}=col(nxC(k)+1:nxC(k+1));
end


if G.isUniform
    for k=1:numedges(G)
        G.qg.Edges.y{k}=col(nxC(k)+1:nxC(k+1));
    end
    % Use the boundary conditions to extend the solution to the vertices
    G.interpAtNodes; 
    
else  % in the case of chebyshev discretization
    
    for k=1:numedges(G)
        G.qg.Edges.y{k}=col(nxC(k)+2:nxC(k+1)-1);
    end

    for k=1:numnodes(G)
        if ~isempty(G.outgoing(k))
           e = G.outgoing(k);
           G.qg.Nodes.y(k) = col(nxC(e(1))+1);
        else
           e = G.incoming(k);
           G.qg.Nodes.y(k) = col(nxC(e(1)+1));
        end
    end
    
end