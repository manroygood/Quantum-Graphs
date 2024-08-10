function plotCoords = starPlotCoords(Phi)
% Creates coordinates on which to lay out functions defined on the star
% These are independent of the coordinates used to define the star
% initially

plotCoords=Phi.initPlotCoords;

n = Phi.numedges;
phi = 2*pi/n*(0:n-1)';
L = Phi.L;
if ismember('stretch',Phi.Edges.Properties.VariableNames)
    for j = find(isinf(L))
        LL=Phi.stretch(j);
        L(j)=sinh(LL);
    end
end
z = L .* exp(1i*phi);

plotCoords.x1Node=[0; real(z)];
plotCoords.x2Node=[0; imag(z)];

for k=1:n
    [x1,x2]= Phi.straightEdge(k,plotCoords);
    plotCoords.x1Edge{k}=x1;
    plotCoords.x2Edge{k}=x2;
end