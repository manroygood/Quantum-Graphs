function flag = hasEdgeField(G,fieldName)

allFields=G.Edges.Properties.VariableNames;

flag = any(strcmp(fieldName,allFields));