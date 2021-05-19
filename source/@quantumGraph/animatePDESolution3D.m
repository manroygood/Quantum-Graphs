function animatePDESolution3D(Phi,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined
realFlag=isreal(U);

nEdges=Phi.numedges;

 nt=length(t);
% l=cell(nt,1);
% clf;
% plot3(nan,nan,nan);
% hold on;
% Phi.column2graph(abs(U(:,1)).^2);
% for k=1:nEdges
%     [x1,x2,x3,y]=Phi.fullEdge(k);
%     y = nan(size(x1));
%     h = colorplot3(x1,x2,x3,y);
%     l{k}.XData = h.XData;
%     l{k}.YData = h.YData;
%     l{k}.ZData = h.ZData;
%     l{k}.CData = h.CData;
% end
% axis equal
% 
% for n=1:nt
%     if realFlag
%         Ut=U(:,n);
%     else
%         Ut=abs(U(:,n)).^2;
%     end
%     for k=1:nEdges
%         Phi.column2graph(Ut);
%         [~,~,~,y]=Phi.fullEdge(k);
%         l{k}.CData=[y y];
%     end
%     title(sprintf('$t=%0.2f$',t(n)))
%     colorbar
%     drawnow
% end
% 
% hold off

for n=1:nt
    hold off
    if realFlag
        Ut=U(:,n);
    else
        Ut=abs(U(:,n)).^2;
    end
    for k=1:nEdges
        Phi.column2graph(Ut);
        [x1,x2,x3,y]=Phi.fullEdge(k);
        colorplot3(x1,x2,x3,y);
        hold on
    end
    title(sprintf('$t=%0.2f$',t(n)))
    view([-70 40])
    axis equal off
    colorbar
    drawnow
end