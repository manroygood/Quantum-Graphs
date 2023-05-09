function plotCoords = mercedeslogoPlotCoords(Phi)

LVec = Phi.L;
L = LVec(1);

phi = pi/2 + 2*pi/3*(0:2);
plotCoords.x1Node = [0 L*cos(phi)]';
plotCoords.x2Node = [0 L*sin(phi)]';

plotCoords.x1Edge = cell(6,1);
plotCoords.x2Edge = cell(6,1);

for k = 1:3
    [x1,x2]=Phi.straightEdge(k,plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end

for k = 4:6
    [x1,x2]=Phi.circularArcEdge(k,2*pi/3,'plus',plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end