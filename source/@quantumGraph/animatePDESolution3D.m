function animatePDESolution3D(G,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 and Nodes.x3 defined
realFlag=isreal(U);
nEdges=G.numedges;
nt=length(t);

for n=1:nt
    hold off
    if realFlag
        Ut=U(:,n);
    else
        Ut=abs(U(:,n)).^2;
    end
    for k=1:nEdges
        G.column2graph(Ut);
        [x1,x2,x3,y]=G.fullEdge(k);
        colorplot3(x1,x2,x3,y);
        hold on
    end
    title(sprintf('$t=%0.2f$',t(n)))
    view([-70 40])
    axis equal off
    colorbar
    drawnow
end