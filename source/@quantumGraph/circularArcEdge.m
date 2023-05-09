function [x1,x2]=circularArcEdge(G,edge,theta,plusminus,plotCoords)
% Create a discretized semicircular segment for plotting a given edge of the
% quantum graph G 

endNodes=G.EndNodes(edge);
node1=endNodes(1);
node2=endNodes(2);
assert(node1~=node2,'Straight edges must start and end at the different nodes')
assert(strcmp(plusminus,'plus')||strcmp(plusminus,'minus'),...
    'plusminus must be ''plus'' or ''minus'' ');
assert(0<theta && theta<2*pi, 'Theta must lie between 0 and 2 pi.')
if strcmp(plusminus,'plus')
    sigma = 1;
else
    sigma = -1;
end

x1start=plotCoords.x1Node(node1);
x1end=plotCoords.x1Node(node2);

x2start=plotCoords.x2Node(node1);
x2end=plotCoords.x2Node(node2);

x1midpoint=(x1start+x1end)/2;
x2midpoint=(x2start+x2end)/2;

displacement=(x1end-x1start)+1i*(x2end-x2start);
d=abs(displacement)/2;
leg = 1i*displacement/tan(theta/2)*sigma/2;
x1center = x1midpoint+real(leg);
x2center = x2midpoint+imag(leg);
xcenter = x1center + 1i*x2center;
xstart = x1start + 1i*x2start;
theta0=angle(xstart-xcenter);
r = d/sin(theta/2);

if strcmp(plusminus,'plus')
    theta=theta0+G.distributePlotCoords(0,theta,edge);
else
    theta=theta0-G.distributePlotCoords(0,theta,edge);
end

x1 = x1center + r*cos(theta);
x2 = x2center + r*sin(theta);
