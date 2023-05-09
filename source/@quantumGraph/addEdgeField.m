function addEdgeField(G,fieldName,fieldData)
% Adds a new column to the Edge table with given name and data

assert(isa(fieldName,'char')||isa(fieldName,'string'),...
    'addEdgeField:wrongEdgeNameType', ...
    'Input fieldName must be char or string type')
if isa(fieldName,'char')
    fieldName=convertCharsToStrings(fieldName);
end

assert(~G.hasEdgeField(fieldName),...
    'addEdgeField:edgeFieldFull','Edge already has field of given name');
nEdges = G.numedges;

assert(isnumeric(fieldData) || iscell(fieldData),...
    'addEdgeField:wrongDataType','Data must be numeric or cell type')

assert(all(size(fieldData)==[nEdges 1])|| all(size(fieldData)==[1 nEdges]),...
    'addEdgeField:wrongDataSize','Data size must match number of edges')

fieldData=fieldData(:); % Convert row data to column data

G.qg.Edges.newField=fieldData;
G.qg.Edges.Properties.VariableNames("newField")=fieldName;