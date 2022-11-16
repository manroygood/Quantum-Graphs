function animatePDESolution3D(G,U,t,nSkip)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 and Nodes.x3 defined

if ~isreal(U)
    U = abs(U).^2;
end
URange=[min(U(:)) max(U(:))];

nt=length(t);

for n=1:nSkip:nt
    clf; hold off;
    G.pcolor3(U(:,n),URange)
    title(sprintf('$t=%0.2f$',t(n)))
    drawnow
end