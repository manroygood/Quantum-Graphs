function L2=getL2NormPML(G,dPML)

nEdges=numedges(G);
weightVec=G.Edges.Weight;
dxVec=G.Edges.dx;
L22Vec=zeros(nEdges,1);
for k=1:nEdges
    L=G.Edges.L(k);
    LMax=L-dPML;
    x=G.Edges.x{k};x=[0;x(:);L]; %#ok<AGROW>
    n1=G.Edges.EndNodes(k,1);
    n2=G.Edges.EndNodes(k,2);
    y=[G.Nodes.y(n1); G.Edges.y{k}; G.Nodes.y(n2)];
    y=y(x<=LMax);
    
    density = (abs(y(1:end-1)).^2+abs(y(2:end).^2))/2;
    % Adjustment for the half-length intervals at the two ends
     density(1)=density(1)/2;
%     if ~isnan(G.Nodes.robinCoeff(n2))
%         density(end)=density(end)/2;
%     end
    
    L22Vec(k)=sum(density);
    
end
L2=sqrt(dot(dxVec.*weightVec,L22Vec));