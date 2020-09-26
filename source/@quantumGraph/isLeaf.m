function z = isLeaf(G,j)
% Tests whether a given node of directed graph G is a leaf

%  in = indegree(G,j);
%  out = outdegree(G,j);
% 
%  deg = in + out;
%  
%  z = (deg == 1);
z = (fulldegree(G,j)==1);