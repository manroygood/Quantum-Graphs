function [x1,x2]=teardropEdge(G,edge,theta0,openingAngle,plotCoords)

endNodes=G.EndNodes(edge);
node1=endNodes(1);
node2=endNodes(2);
assert(node1==node2,'Teardrop edges must start and end at the same node')

c = tan(openingAngle/2)/2;
syms t
x = sin(t);
y = c*sin(2*t);
ds = matlabFunction(sqrt(diff(x)^2+diff(y)^2));
arcLength = integral(ds,0,pi);

theta =  G.distributePlotCoords(0,pi,edge);

L=G.L(edge);
r= L/arcLength;
x10 = plotCoords.x1Node(node1);
x20 = plotCoords.x2Node(node1);

xx = r*sin(theta);
yy = r*c*sin(2*theta);

A = [cos(theta0) -sin(theta0); sin(theta0) cos(theta0)];
xy = [xx yy]*A;

x1 = x10 + xy(:,1);
x2 = x20 + xy(:,2);
