function M = extendedLaplacian(G)

assert(G.hasDiscretization('Uniform'),'Extended Laplacian needs to have uniform discretization')
nEdges=G.numedges;
nNodes=G.numnodes;
[~,nxC,nxTot]=nx(G);
LMat=G.laplacianMatrix ;
WMat=G.weightMatrix;
EMat=speye(nxTot);

[~,~,~,row]=getBounds(nxC,nEdges);
for j=1:nNodes   % Loop over the nodes
    [fullDegree,inOrOut,connectedEdges] = G.fullDegreeEtc(j);
    GhostMat=zeros(fullDegree);
    InteriorMat=zeros(fullDegree);
    for k=1:fullDegree   % Loop over the edges connected to the node
        row=row+1;
        
        if k ==1    % At first entry of block, enforce either Dirichlet or flux condition & put a one in the right spot of VCAMat
            if G.isDirichlet(j)  % Define Dirichlet Boundary Condition
                GhostMat(1,1)= 1/2;
                InteriorMat(1,1) = -1/2;
            else                 % Define flux condition
                for branch = 1:fullDegree
                    edge = connectedEdges(branch);
                    direction = inOrOut(branch);
                    [ghostPt,interiorPt] = getEndPoints(G,direction,edge);
                    GhostMat(1,branch) = LMat(row,ghostPt);
                    InteriorMat(1,branch) = -  LMat(row,interiorPt);
                end
            end
        else                 % At remaining entries of  block, enforce continuity condition
            GhostMat(k,1) = -1; InteriorMat(k,1) = 1;
            GhostMat(k,k) =  1; InteriorMat(k,k) = -1;
        end
    end
    
    EMatNode= GhostMat\InteriorMat;
    
    for iRow=1:fullDegree
        edge = connectedEdges(iRow);
        direction = inOrOut(iRow);
        [ghostRow,~] = G.getEndPoints(direction,edge);
        EMat(ghostRow,ghostRow)=0;
        for jColumn=1:fullDegree
            edge = connectedEdges(jColumn);
            direction = inOrOut(jColumn);
            [~,interiorColumn] = G.getEndPoints(direction,edge);
            EMat(ghostRow,interiorColumn) = EMatNode(iRow,jColumn); %#ok<*SPRIX> 
        end
    end
end

M = EMat*WMat'*LMat;