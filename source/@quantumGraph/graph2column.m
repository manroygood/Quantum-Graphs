function col = graph2column(G)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

nx = G.Edges.nx;
nn=[0;cumsum(nx)];
col=zeros(nn(end),1);

for k=1:numedges(G)
    col(nn(k)+1:nn(k+1))=G.Edges.y{k}(:);
end