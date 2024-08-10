function constructIntegrationWeightsUniform(G)

nEdges=G.numedges;


G.qg.Edges.integrationWeight= cell(nEdges,1);
nx=G.nx;
L = G.L;
for k=1:nEdges
    if isinf(L(k))
        n = nx(k); ds = 1/n;
        stretch = G.stretch(k);
        s = linspace(-ds/2,1+ds/2,n+2)';
        G.qg.Edges.integrationWeight{k} = ds*stretch*cosh(stretch*s);
    else
        G.qg.Edges.integrationWeight{k}=L(k) / nx(k);
    end
end
