function plotCoords = poissonExamplePlotCoords(G)

L=G.L;

if isinf(L(5))
    x5=sinh(G.stretch(5));
else
    x5 = L(5);
end
theta=pi/6;
plotCoords.x1Node=[0;L(3);L(3)+x5*cos(theta)];
plotCoords.x2Node=[0;0;x5*sin(theta)];
plotCoords.x1Edge = cell(5,1);
plotCoords.x2Edge = cell(5,1);

% Left hoop 1
edge=1;
[hoop1LeftX1,hoop1LeftX2] = G.teardropEdge(edge,5*pi/4,pi/3,plotCoords);

% Left hoop 1
edge=2;
[hoop2LeftX1,hoop2LeftX2] = G.teardropEdge(edge,3*pi/4,pi/3,plotCoords);

% Handle
edge=3;
[handleX1,handleX2] = G.straightEdge(edge,plotCoords);

% Right hoop
edge=4;
[hoopRightX1,hoopRightX2] = G.teardropEdge(edge,pi/4,pi/3,plotCoords);

% Dangling Edge
edge=5;
[dangleX1,dangleX2]=G.straightEdge(edge,plotCoords);

plotCoords.x1Edge={hoop1LeftX1; hoop2LeftX1; handleX1; hoopRightX1; dangleX1};
plotCoords.x2Edge={hoop1LeftX2; hoop2LeftX2; handleX2; hoopRightX2; dangleX2};