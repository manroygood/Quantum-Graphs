function P=getMomentumPML(G,dPML)

nEdges=numedges(G);
weightVec=G.Edges.Weight;
PVec=zeros(nEdges,1);
mVec=G.Edges.m;
for k=1:nEdges
    L=G.Edges.L(k);
    LMax=L-dPML;

    x=G.Edges.x{k};

    
    x=[0;x(:);L]; 
    
    n1=G.Edges.EndNodes(k,1);
    n2=G.Edges.EndNodes(k,2);
    y=[G.Nodes.y(n1); G.Edges.y{k}(:); G.Nodes.y(n2)];
       y=y(x<=LMax); 
    yy = conj(y(1:end-1)+y(2:end))/2;
    dy = diff(y);

    density = imag(yy.*dy);
    
    %     % Adjustment for the half-length intervals at the two ends
    %     density(1)=density(1)/2;
    %     if ~isnan(G.Nodes.robinCoeff(n2))
    %         density(end)=density(end)/2;
    %     end
    
    PVec(k)=sum(density);
    
end
P=dot(weightVec.*mVec,PVec);