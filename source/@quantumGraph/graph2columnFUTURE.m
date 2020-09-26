function col = graph2column(G,component)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

nDep=G.numDependent;
[~,nxC,nxTot] = G.Edges.nx;

if exist('component','var')
    assert(component<=nDep,'specified component must be less than number of dependent variables')
    col=zeros(nxC(end),1);
        for k=1:numedges(G)
            top = nxC(k)+1;
            bottom=nxC(k+1);
            col(top:bottom)=G.Edges.y{k}(:,component);
        end    
else
    col=zeros(nxC(end)*nDep,1);
    for j = 1: nDep
        start=(j-1)*nxTot;
        for k=1:numedges(G)
            top = start+nxC(k)+1;
            bottom=start+nxC(k+1);
            col(top:bottom)=G.Edges.y{k}(:,j);
        end
    end
    
end