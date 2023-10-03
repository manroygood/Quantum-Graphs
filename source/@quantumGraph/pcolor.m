function pcolor(G,u,uRange)

if ~exist('u','var')
    u=G.graph2column;
else
    G.column2graph(u);
end

if ~exist('uRange','var')
    uRange=[min(u) max(u)];
end

cla;hold off
for k=1:G.numedges
    [y,x1,x2]=G.fullEdge(k);
    colorplot2(x1,x2,y,uRange);
    hold on
end
% for k=1:G.numedges
%     [y,x1,x2]=G.fullEdge(k);
%     yS=y(1:end-1).*y(2:end);
%         signChanges=find(yS<0); nsC=length(signChanges);
%         if nsC>0
%             s = y(signChanges)./(y(signChanges)-y(signChanges+1));
%             x1s=x1(signChanges)+ s.*(x1(signChanges+1)-x1(signChanges));
%             x2s=x2(signChanges)+ s.*(x2(signChanges+1)-x2(signChanges));
%             plot(x1s,x2s,'ko','markerfacecolor','k')
%         end
% end

axis equal off
view([0 90])

colorbar