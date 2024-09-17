function plotGraphLayout2D(G,muteFlag)

creamcolor=mcolor('eggshell');
blueish=mcolor('blueish');
reddish=mcolor('reddish');
lightgray=mcolor('lightgray');
clf;hold on
if ismember('relinked', G.qg.Edges.Properties.VariableNames)
    relinked=G.qg.Edges.relinked;
else
    relinked=zeros(G.numedges,1);
end
Edges=G.Edges; Nodes=G.Nodes;
leftends=zeros(G.numedges,2);rightends=zeros(G.numedges,2);
for k=1:numedges(G)
    [~,x1,x2]=G.fullEdge(k);
    ww=Edges.Weight(k)*2;
    nextLine=plot(x1,x2,'color',blueish,'linewidth',ww);
    if relinked(k); set(nextLine,'color',reddish);end
    if ~muteFlag
        assert(exist('arrow3')==2,'The arrow3 package required for this function')
        midpt = ceil(G.nx(k)*0.55);
        x1m = x1(midpt); dx1=diff(x1(midpt+[-1 1]));
        x2m = x2(midpt); dx2=diff(x2(midpt+[-1 1]));
        dx = sqrt(dx1^2+dx2^2); dx1=dx1*.1/dx;
        dx2 = dx2*.1/dx;
        leftends(k,:)=[x1m x2m];
        rightends(k,:)=[x1(midpt+1) x2(midpt+1)];%[x1m+dx1 x2m+dx2];
        midpt = ceil(G.nx(k)*0.65);
        x1m = x1(midpt);
        x2m = x2(midpt);
        text(x1m,x2m,int2str(k),'fontsize',18,'edgecolor','k','background',creamcolor,'horizontalalignment','center')

    end
end
daspect([1 1 1]);
colorarray=zeros(2,21,3);
for j=1:21
    colorarray(1,j,:)=blueish;
end
if ~muteFlag; hh=arrow3(leftends,rightends,'^b');
    for j=1:length(hh)
        props=get(hh(j));
        if strcmp(props.Type,'surface')
            set(hh(j),'CData',colorarray)
        end
    end
end
%axis equal
xlim=get(gca,'xlim'); dx=diff(xlim)/30;

plot(Nodes.x1,Nodes.x2,'o','color',blueish,'markersize',10,'MarkerFaceColor',blueish)

if ~muteFlag

    for k=1:numnodes(G)
        text(Nodes.x1(k)+dx,Nodes.x2(k)+dx,int2str(k),'fontsize',18,'horizontalalignment','center',...
            'edgecolor','k','background',lightgray)
    end
end

hold off
axis equal off tight
set(gcf,'color','w')