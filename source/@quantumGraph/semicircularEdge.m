function [x1,x2]=semicircularEdge(G,edge,plusminus,plotCoords)
% Create a discretized line segment for plotting a given edge of the
% quantum graph G 

endNodes=G.EndNodes(edge);
node1=endNodes(1);
node2=endNodes(2);
assert(node1~=node2,'Straight edges must start and end at the different nodes')
assert(strcmp(plusminus,'plus')||strcmp(plusminus,'minus'),...
    'plusminus must be ''plus'' or ''minus'' ');

x1start=plotCoords.x1Node(node1);
x1end=plotCoords.x1Node(node2);

x2start=plotCoords.x2Node(node1);
x2end=plotCoords.x2Node(node2);

x1center=(x1start+x1end)/2;
x2center=(x2start+x2end)/2;

displacement=(x1end-x1start)+1i*(x2end-x2start);
theta0=angle(displacement);
r=abs(displacement)/2;

if strcmp(plusminus,'plus')
    theta=theta0+G.distributePlotCoords(0,pi,edge);
else
    theta=theta0-G.distributePlotCoords(0,pi,edge);
end

x1 = x1center - r*cos(theta);
x2 = x2center - r*sin(theta);