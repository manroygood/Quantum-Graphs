function animatePDESolution2D(Phi,U,t)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined
realFlag=isreal(U);

myBlue = [0 0.4470 0.7410]; % The default MATLAB line color
myGray = 0.7*[1 1 1];
nEdges=Phi.numedges;

nt=length(t);
l=cell(nEdges,1);
clf;
plot3(nan,nan,nan);
hold on;
Phi.column2graph(abs(U(:,1)).^2);
for k=1:nEdges
    [x1,x2]=Phi.fullEdge(k);
    ww=Phi.weight(k)*2;
    plot3(x1,x2,zeros(size(x1)),'color',myGray,'linewidth',ww);
    l{k} = plot3(nan,nan,nan);
    l{k}.XData = [];
    l{k}.YData = [];
    l{k}.ZData = [];
    l{k}.Color = myBlue;
    l{k}.LineWidth = ww;
end

[x1Range,x2Range]=plotRange(Phi);
xRange = min(x1Range,x2Range);
if realFlag
    zMin=min(min(U));
    zMax=max(max(U));
else
    zMin=0;
    zMax=max(max(abs(U).^2));
end
zRange=zMax-zMin;

set(gca,'DataAspectRatio',[xRange xRange 1.25*zRange])
set(gca,'ZLim',[zMin,1.1*zMax])


for n=1:nt
    if realFlag
        Ut=U(:,n);
    else
        Ut=abs(U(:,n)).^2;
    end
    for k=1:nEdges
        Phi.column2graph(Ut);
        [x1,x2,y]=Phi.fullEdge(k);
        l{k}.XData=x1;
        l{k}.YData=x2;
        l{k}.ZData=y;
    end
    title(sprintf('$t=%0.1f$',t(n)))
    drawnow
end

hold off
