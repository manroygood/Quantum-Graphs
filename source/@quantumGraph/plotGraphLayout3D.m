function plotGraphLayout3D(G,muteFlag)
creamcolor=mcolor('eggshell');
blueish=mcolor('blueish');
lightgray=mcolor('lightgray');

clf;
Edges=G.Edges; Nodes=G.Nodes;
for k=1:numedges(G)
    [~,x1,x2,x3]=G.fullEdge(k);
    ww=Edges.Weight(k)*2;
    plot3(x1,x2,x3,'color',blueish,'linewidth',ww);
    hold on;

    % if ~muteFlag
    %     x1m=(x1(1)+x1(end))/2;
    %     x2m=(x2(1)+x2(end))/2;
    %     x3m=(x3(1)+x3(end))/2;
    %     text(x1m,x2m,x3m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')
    % end
    if ~muteFlag
        midpt = ceil(G.nx(k)*0.55);
        x1m = x1(midpt); dx1=diff(x1(midpt+[-1 1]));
        x2m = x2(midpt); dx2=diff(x2(midpt+[-1 1]));
        x3m = x3(midpt); dx3=diff(x3(midpt+[-1 1]));
        dx = sqrt(dx1^2+dx2^2+dx3^2);
        dx1 = dx1*.1/dx;
        dx2 = dx2*.1/dx;
        dx3 = dx3*.1/dx;
        leftends(k,:)=[x1m x2m x3m];
        rightends(k,:)=[x1(midpt+1) x2(midpt+1) x3(midpt+1)];%[x1m+dx1 x2m+dx2];
        midpt = ceil(G.nx(k)*0.65);
        x1m = x1(midpt);
        x2m = x2(midpt);
        x3m = x3(midpt);
        text(x1m,x2m,x3m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')

    end
end
%axis equal
if ~muteFlag

    daspect([1 1 1]);
    colorarray=zeros(2,21,3);
    for j=1:21
        colorarray(1,j,:)=blueish;
    end
    if (exist('arrow3','file')==2)
        hh=arrow3(leftends,rightends,'^b');
        for j=1:length(hh)
            props=get(hh(j));
            if strcmp(props.Type,'surface')
                set(hh(j),'CData',colorarray)
            end
        end
    else
        warning(['The arrow3 package is required to annotate the edges with direction arrows. ' ...
            'Find it at https://www.mathworks.com/matlabcentral/fileexchange/14056-arrow3 or '...
            'use the Add-Ons menu in the Home tab on the MATLAB Desktop.'])
    end
end
xlim=get(gca,'xlim'); dx=diff(xlim)/30;

plot3(Nodes.x1,Nodes.x2,Nodes.x3,'o','color',blueish, 'markersize',10,'MarkerFaceColor',blueish)

if ~muteFlag
    for k=1:numnodes(G)
        text(Nodes.x1(k)+dx,Nodes.x2(k)+dx,Nodes.x3(k)+dx,int2str(k),'fontsize',18,'horizontalalignment','center',...
            'edgecolor','k','background',lightgray)
    end
end

hold off
axis equal tight off
set(gcf,'color','w')