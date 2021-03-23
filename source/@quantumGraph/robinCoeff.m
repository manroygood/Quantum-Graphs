function rc = robinCoeff(G,j)
if nargin ==1
    rc = G.qg.Nodes.robinCoeff;
else
    rc = G.qg.Nodes.robinCoeff(j);
end
end
