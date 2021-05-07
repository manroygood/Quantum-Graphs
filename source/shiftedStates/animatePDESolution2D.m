function animatePDESolution2D(U,Phi,t,dPML)

xx=zeros(sum(Phi.Edges.nx),1);
[~,nxc,~]=Phi.nx;
for k=1:numedges(Phi)
    x1=Phi.Edges.x{k};
    xx(nxc(k)+1:nxc(k+1))=x1(:);
end
L=Phi.Edges.L(1)-dPML;
nT=length(t);

clf

Umax = max(max(abs(U.^2)));
set(gca,'nextplot','replacechildren','visible','off')
set(gcf, 'Color', [1 1 1])

figure(gcf);
for k=1:nT
    cla
    plotLeftRight(U(:,k),Phi,dPML);
    axis([-L L 0 Umax*1.05;]);
    xlabel('x');
    title(sprintf('t=%0.1f',t(k)))
    axis on
    legend('Edge 1','Edge 2','Edge 3','Location','northwest')
    drawnow    
end