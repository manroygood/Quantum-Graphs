function column2graph(G,col,component)
% Assigns the a column vector (of the right length) to the Edges.y field of
% a quantum graph with the same structure as template

[nx,nxC,nxTot] = G.nx;
if ~exist('component','var')
    assert(mod(length(col),nxTot) == 0,'Column and template not compatible.')
    nDep=length(col)/nxTot;
    
    for k=1:numedges(G)
        temp=zeros(nx(k),nDep);
        for j = 1: nDep
            start=(j-1)*nxTot;
            top = start+nxC(k)+1;
            bottom=start+nxC(k+1);
            temp(:,j)=col(top:bottom);
        end
        G.qg.Edges.y{k}=temp;
    end
    
else
    for k=1:numedges(G)
%        temp=zeros(nx(k),1);
        start=(component-1)*nxTot;
        top = start+nxC(k)+1;
        bottom=start+nxC(k+1);
        temp=col(top:bottom);
        G.qg.Edges.y{k}(:,component)=temp;
    end
            
end
% Use the boundary conditions to extend the solution to the vertices
G.interpAtNodes;