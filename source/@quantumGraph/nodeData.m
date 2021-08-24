function y = nodeData(G,j)

y=G.qg.Nodes.nodeData;
if nargin==2
    y=y(j);
end