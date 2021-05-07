function E=getEnergyPML(G,dPML)

nEdges=numedges(G);
weightVec=G.Edges.Weight;
dxVec=G.Edges.dx;
pVec=zeros(nEdges,1);
for k=1:nEdges
    L=G.Edges.L(k);
    LMax=L-dPML;
    x=G.Edges.x{k};x=[0;x(:);L]; %#ok<AGROW>
    
    n1=G.Edges.EndNodes(k,1);
    n2=G.Edges.EndNodes(k,2);
    y=[G.Nodes.y(n1); G.Edges.y{k}(:); G.Nodes.y(n2)];
        y=y(x<=LMax);
    yp2=abs(y).^4;
    densityNL = (yp2(1:end-1)+yp2(2:end))/2;
    densityD = abs(diff(y)/dxVec(k)).^2;
       
%     % Adjustment for the half-length intervals at the central vertex
     densityD(1)=densityD(1)*2;
     densityNL(1) = densityNL(1)/2;
     if ~isnan(G.Nodes.robinCoeff(n2))
         densityD(end)=densityD(end)*2;
         densityNL(end)=densityNL(end)/2;
     end

    densityD =  densityD - densityNL ;
    pVec(k)=sum(densityD);    
end
E=dot(weightVec.*dxVec,pVec);