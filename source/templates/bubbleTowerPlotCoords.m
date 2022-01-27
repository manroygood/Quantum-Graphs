function plotCoords = bubbleTowerPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the dumbbell
% These are independent of the coordinates used to define the dumbbell
% initially

nNodes = Phi.numnodes;
nEdges=Phi.numedges;
n=(nEdges-1)/2;

L= Phi.L(1);

r= [Phi.L(3:2:2*n-1)/pi ; Phi.L(end)/2/pi];

plotCoords.x1Node=zeros(nNodes,1);
plotCoords.x2Node=zeros(nNodes,1);

plotCoords.x1Node(2:3) = L*[-1;1];
plotCoords.x2Node(4:nNodes)=2*cumsum(r(1:end-1));

plotCoords.x1Edge = cell(nEdges,1);
plotCoords.x2Edge = cell(nEdges,1);

nx=Phi.nx;
n1=nx(1);
x=Phi.distributePlotCoords(0,L,1);
plotCoords.x1Edge{1} = -x;
plotCoords.x2Edge{1} = zeros(n1+2,1);

plotCoords.x1Edge{2} = x;
plotCoords.x2Edge{2} = zeros(n1+2,1);

rr=2*cumsum([0;r]);
for k = 1:n-1
    theta = Phi.distributePlotCoords(0,pi,k);
    x= r(k)*sin(theta);
    y= rr(k)+r(k)*(1-cos(theta));
    plotCoords.x1Edge{2*k+1} = -x;
    plotCoords.x2Edge{2*k+1} = y;
    
    plotCoords.x1Edge{2*k+2} = x;
    plotCoords.x2Edge{2*k+2} = y;
end

theta = Phi.distributePlotCoords(0,2*pi,n);
x= r(end)*sin(theta);
y= rr(end-1)+r(end)*(1-cos(theta));
plotCoords.x1Edge{2*n+1} = -x;
plotCoords.x2Edge{2*n+1} = y;