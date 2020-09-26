function val=hasDiscretization(G)
Exist_Column = strcmp('nx',G.Edges.Properties.VariableNames);
val = sum(Exist_Column)>0;