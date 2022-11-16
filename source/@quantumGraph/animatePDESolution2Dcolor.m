function animatePDESolution2Dcolor(G,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined
clf;
if ~isreal(U)
    U = abs(U).^2;
end
URange=[min(U(:)) max(U(:))];
nt=length(t);

for k=1:nt
    cla
    G.pcolor(U(:,k),URange)
    title(sprintf('$t=%0.2f$',t(k)))
    drawnow
end