function plotCoords = tribellPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the tribell
% These are independent of the coordinates used to define the tribell
% initially

LVec=Phi.L;
r=LVec(4)/2/pi;
L1=LVec(1);

nBells =3;
phi = 2*pi/nBells*(0:nBells-1)';
z = L1 *exp(1i*phi);
plotCoords.x1Node=[0; real(z)];
plotCoords.x2Node=[0; imag(z)];

n1=Phi.Edges.nx(1);
x = ((1:n1)-1/2)'/n1;

n2=Phi.Edges.nx(nBells+1);
theta=2*pi*((1:n2)-1/2)'/n2;

handle = L1*x;
hoop = L1 +r -r*exp(1i*theta);

plotCoords.x1Edge = cell(2*nBells,1);
plotCoords.x2Edge = cell(2*nBells,1);

for j=1:nBells
    z =handle*exp(1i*phi(j));
    plotCoords.x1Edge{j}=real(z);
    plotCoords.x2Edge{j}=imag(z);
    z =hoop*exp(1i*phi(j));
    plotCoords.x1Edge{j+3}=real(z);
    plotCoords.x2Edge{j+3}=imag(z);
end