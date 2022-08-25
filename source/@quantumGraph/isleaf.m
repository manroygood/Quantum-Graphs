function z = isleaf(G,j)
% Tests whether a given node of directed graph G is a leaf

z = (fulldegree(G,j)==1);