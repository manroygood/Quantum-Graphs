function y = incomingedges(G,j)
% A simple but missing command to find all incoming edges at node j
y = findedge(G.qg,predecessors(G.qg,j),j);