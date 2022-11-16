function animatePDESolution2Dcolor(G,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 and Nodes.x3 defined
clf;
if ~isreal(U)
    U = abs(U).^2;
end
URange=[min(U(:)) max(U(:))];nEdges=G.numedges;
nt=length(t);

for n=1:nt
    G.pcolor(U(:,n),URange)
    title(sprintf('$t=%0.2f$',t(n)))
    drawnow
end