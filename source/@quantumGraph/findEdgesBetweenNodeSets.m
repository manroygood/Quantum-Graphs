function nodeList=findEdgesBetweenNodeSets(Phi,sourceNodes,targetNodes)
sourceNodes=sourceNodes(:);
targetNodes=targetNodes(:);
Edges=Phi.Edges.EndNodes;
nodeList=find(sum(Edges(:,1)==sourceNodes',2) & sum(Edges(:,2)==targetNodes',2));