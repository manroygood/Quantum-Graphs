function interpAtNodes(G)
% Interpolates the Edges.y field of a quantum graph G to the Nodes.y field

nDep=numDependent(G);
nNodes=numnodes(G);
yNodes=zeros(nNodes,1);

for j = 1:nDep
    for k = 1:nNodes
        if isnan(G.robinCoeff(k))
            yNodes(k,j)=0;
        else
            mat = G.ghostMatrix(k);
            [fullDegree,inOrOut,allEdges]=fullDegreeEtc(G,k);
            yNodes(k,j) = firstValue(1,j)/2;
            for branch = 1:fullDegree   % loop over all edges adjacent to given nodes (rows of matrix)
                yNodes(k,j) = yNodes(k,j)+ mat(1,branch)*firstValue(branch,j)/2;
            end
        end
    end
end
G.qg.Nodes.y=yNodes;

    function yy = firstValue(k,j)  % Nested function
        y = G.y(allEdges(k));
        if inOrOut(k)==1
            yy =y(end,j);
        else
            yy = y(1,j);
        end
    end

end