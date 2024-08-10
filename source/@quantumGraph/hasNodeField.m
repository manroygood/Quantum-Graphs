function flag = hasNodeField(G,fieldName)

allFields=G.Nodes.Properties.VariableNames;

flag = any(strcmp(fieldName,allFields));