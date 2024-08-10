function col = integrationWeight2column(G)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

[~,nxC,nxTot] = G.nx;
col=zeros(nxTot,1);


if strcmp(G.discretization,'Chebyshev')
    for k=1:numedges(G)

        col(nxC(k)+1:nxC(k+1))=G.integrationWeight{k};
    end
elseif strcmp(G.discretization,'Uniform')
    for k=1:numedges(G)
        if ~isinf(G.L(k))
            col(nxC(k)+2:nxC(k+1)-1)=G.integrationWeight{k};
        else
            w=G.integrationWeight{k};
            col(nxC(k)+1:nxC(k+1))=G.integrationWeight{k};
        end

    end
end
