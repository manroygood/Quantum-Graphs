function asymmetry=getL2Asymmetry(G)

%nEdges=numedges(G);
weightVec=G.Edges.Weight;
dxVec=G.Edges.dx;
%L22Vec=zeros(nEdges,1);


n1=G.Edges.EndNodes(2,1);
n2=G.Edges.EndNodes(2,2);
y2=[G.Nodes.y(n1); G.Edges.y{2}(:); G.Nodes.y(n2)];

n1=G.Edges.EndNodes(3,1);
n2=G.Edges.EndNodes(3,2);
y3=[G.Nodes.y(n1); G.Edges.y{3}(:); G.Nodes.y(n2)];


density2 = (abs(y2(1:end-1)).^2+abs(y2(2:end).^2))/2;
% Adjustment for the half-length intervals at the two ends
density2(1)=density2(1)/2;
if ~isnan(G.Nodes.robinCoeff(n2))
    density2(end)=density2(end)/2;
end
L22=sqrt(dxVec(2)*weightVec(2)*sum(density2));

density3 = (abs(y3(1:end-1)).^2+abs(y3(2:end).^2))/2;
% Adjustment for the half-length intervals at the two ends
density3(1)=density3(1)/2;
if ~isnan(G.Nodes.robinCoeff(n2))
    density3(end)=density3(end)/2;
end
L23=sqrt(dxVec(2)*weightVec(2)*sum(density3));
asymmetry=L22-L23;