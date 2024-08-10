function flag = hasPlotLayout(G)
if ismember('x1',G.qg.Nodes.Properties.VariableNames)
    flag=true;
else
    flag=false;
end