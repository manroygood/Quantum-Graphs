function constructIntegrationWeightsChebyshev(G)

nEdges=G.numedges;

G.qg.Edges.integrationWeight= cell(nEdges,1);
nx=G.nx;
L = G.L;
for k=1:nEdges
    N1=nx(k)+2;
    N = N1-1;
    c=zeros(N1,2);
    c(1:2:N1,1)=(2./[1 1-(2:2:N).^2 ])'; c(2,2)=1;
    g=real(ifft([c(1:N1,:);c(N:-1:2,:)]));
    g=([g(1,1); 2*g(2:N,1); g(N1,1)])/2;
    if isinf(L(k))
        stretch=G.stretch(k);
        n=nx(k);
        sExt = chebptsSecondKind(n);
        W = stretch*cosh(stretch*(1-sqrt(1-sExt)))/2./sqrt(1-sExt);W(end)=0;
        W = W;
        G.qg.Edges.integrationWeight{k}=W.*g;
    else
        G.qg.Edges.integrationWeight{k}=g*L(k);
    end
end