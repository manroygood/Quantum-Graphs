function y = outgoing(G,j)
% A simple but missing command to find all outgoing edges at node j
y = findedge(G.qg,j,successors(G.qg,j));