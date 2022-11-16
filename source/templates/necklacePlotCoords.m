function plotCoords = necklacePlotCoords(Phi)
% All lengths plotted correspond to actual edge lengths
% This means that for some configurations, the graph will appear to
% self-intersect

plotCoords=Phi.initPlotCoords;

L = Phi.L;
nPearls = Phi.numedges/3;

lString=L(1);
rPearl = L(2)*2/pi;

[plotCoords.x1Node,plotCoords.x2Node]=necklaceNodes(nPearls,lString,rPearl);

for j=1:nPearls
    [arcX1,arcX2]=Phi.semicircularEdge(3*j-2,'plus',plotCoords);
    plotCoords.x1Edge{3*j-2}=arcX1;
    plotCoords.x2Edge{3*j-2}=arcX2;

    [arcX1,arcX2]=Phi.semicircularEdge(3*j-1,'minus',plotCoords);
    plotCoords.x1Edge{3*j-1}=arcX1;
    plotCoords.x2Edge{3*j-1}=arcX2;

    [lineX1,lineX2]=Phi.straightEdge(3*j,plotCoords);
    plotCoords.x1Edge{3*j}=lineX1;
    plotCoords.x2Edge{3*j}=lineX2;
end
end
function [x,y]=necklaceNodes(nPearls,lString,rPearl)

objective = @(alpha) lString/rPearl - lengthRatio(nPearls,alpha);

alpha = fzero(objective,1/2);
[z3,z4]= myZ(nPearls,alpha);

theta = 2*pi/nPearls;

zz=exp(1i*(0:nPearls-1)*theta).';
zOdd=z3*zz;
zEven=z4*zz;

z=zeros(2*nPearls,1);
z(1:2:end)=zOdd;
z(2:2:end)=zEven;
z= z*lString/2/imag(z(1));
%z=shift(z,-1); % lazy fix
x=real(z);y=imag(z);
end

function ratio = lengthRatio(n,alpha)
assert(0<alpha && alpha<1, 'Must have 0<alpha<1')
[z3,z4]= myZ(n,alpha);
l1 = 2*imag(z3);
l2 = abs(z4-z3);
ratio = l1/l2;

end

function [z3,z4]= myZ(n,alpha)
theta=2*pi/n;
z0=1;
z1 = exp(1i*theta);
z2 = z0+(z1-z0)/2;
z3 = z0 + alpha*(z2-z0);
z4 = z1 + alpha*(z2-z1);
end