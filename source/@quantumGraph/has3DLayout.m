function flag = has3DLayout(G)
if ismember('x3',G.qg.Nodes.Properties.VariableNames)
    flag=true;
else
    flag=false;
end