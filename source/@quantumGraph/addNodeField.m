function addNodeField(G,fieldName,fieldData)

assert(~G.hasNodeField(fieldName),...
    'addNodeField:nodeFieldFull','Node already has field of given name');
nNodes = G.numnodes;

assert(isnumeric(fieldData) || iscell(fieldData),...
    'addNodeField:wrongDataType','Data must be numeric or cell type')

assert(all(size(fieldData)==[nNodes 1])|| all(size(fieldData)==[1 nNodes]),...
    'addNodeField:wrongDataSize','Data size must match number of nodes')

fieldData=fieldData(:); % Convert row data to column data

G.qg.Nodes=addvars(G.qg.Nodes,fieldData);
varnames=G.qg.Nodes.Properties.VariableNames;
oldName=varnames{end};
G.qg.Nodes=renamevars(G.qg.Nodes,oldName,fieldName);