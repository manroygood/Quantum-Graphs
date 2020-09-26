function n=numDependent(G)

if ~ismember('y',G.qg.Edges.Properties.VariableNames)
    n=0;
else
    n=size(G.qg.Edges.y,2);
end