function col = graph2column(G)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

[~,nxC,nxTot] = G.nx;
col=zeros(nxTot,1);

for k=1:numedges(G)
    col(nxC(k)+1:nxC(k+1))=G.y{k}(:);
end