function animatePDESolution2D(G,U,t,nSkip)
% Plots a graph G over its skeleton.
% Graph must have Nodes.x1 and Nodes.x2 defined
% Plotting is odne in a very unusual way, by manually changing the XData,
% YData, and ZData. This is to keep the axes box fixed between frames of
% the animation, following the answer given by Ameer Hamza here:
% https://www.mathworks.com/matlabcentral/answers/388084-how-to-keep-axes-box-fixed-when-creating-an-animation
clf;
realFlag=isreal(U);
if ~realFlag
    U=abs(U).^2;
end

myBlue = [0 0.4470 0.7410]; % The default MATLAB line color
myGray = 0.7*[1 1 1];
nEdges=G.numedges;

nt=length(t);
l=cell(nEdges,1);
clf;
plot3(nan,nan,nan);
hold on;
G.column2graph(U(:,1));
for k=1:nEdges
    [~,x1,x2]=G.fullEdge(k);
    ww=G.weight(k)*2;
    plot3(x1,x2,zeros(size(x1)),'color',myGray,'linewidth',ww);
    l{k} = plot3(nan,nan,nan);
    l{k}.XData = [];
    l{k}.YData = [];
    l{k}.ZData = [];
    l{k}.Color = myBlue;
    l{k}.LineWidth = ww;
end

[x1Range,x2Range]=plotRange(G);
xRange = min(x1Range,x2Range);
if realFlag
    zMin=min(min(U));
    zMax=max(max(U));
else
    zMin=0;
    zMax=max(max(U));
end
zRange=zMax-zMin;

set(gca,'DataAspectRatio',[xRange xRange 1.25*zRange])
set(gca,'ZLim',[zMin,1.1*zMax])

for n=1:nSkip:nt
    Ut=U(:,n);
    G.column2graph(Ut);
    for k=1:nEdges
        [y,x1,x2]=G.fullEdge(k);
        l{k}.XData=x1;
        l{k}.YData=x2;
        l{k}.ZData=y;
    end
    title(sprintf('$t=%0.1f$',t(n)))
    drawnow
end

hold off