function [x1,x2]=circularEdge(G,edge,theta0,plotCoords)

endNodes=G.EndNodes(edge);
node1=endNodes(1);
node2=endNodes(2);
assert(node1==node2,'Circular edges must start and end at the same node')

if isstring(theta0)||ischar(theta0)
    if strcmp(theta0,'right')
        theta0 = pi;
    elseif strcmp(theta0,'left')
        theta0 = 0;
    elseif strcmp(theta0,'up')
        theta0 = -pi/2;
    elseif strcmp(theta0,'down')
        theta0 = pi/2;
    end
end

theta = theta0 + G.distributePlotCoords(0,2*pi,edge);

L=G.L(edge);
r=L/2/pi;
x10 = plotCoords.x1Node(node1)-r*cos(theta0);
x20 = plotCoords.x2Node(node1)-r*sin(theta0);

x1 = x10 + r*cos(theta);
x2 = x20 + r*sin(theta);
