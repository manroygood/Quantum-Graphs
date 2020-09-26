function nLeaf = countLeaf(G)

nNode=numnodes(G);
leafVec=zeros(nNode,1);
for j=1:nNode
  leafVec(j)=isLeaf(G,j);
end
nLeaf=sum(leafVec);