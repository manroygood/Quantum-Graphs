function [fullDegree,inOrOut,allEdges]=fullDegreeEtc(G,j)

% Calculate the total degree of node j
fullDegree = indegree(G.qg,j)+outdegree(G.qg,j);

% Find Incoming and Outgoing Edges and combine to get all edges
ic = G.incomingedges(j);
og = G.outgoingedges(j);
allEdges = [ic ; og];

% A one-dimensional array with values +1 at incoming and -1 at outgoing
inOrOut = [ones(size(ic));  -1*ones(size(og))];