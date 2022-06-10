function robin = robinCondition(G,node,D1matrix)
    % Finds the Robin Condition for the given node
    
        alpha = G.robinCoeff;
        [fullDegree,inOrOut,adjacentEdges] = G.fullDegreeEtc(node);
        
        if G.isDirichlet(node)
            robin = G.ek(node,1);
        else
            for k = 1:fullDegree
                c = inOrOut(k);
                w = G.Edges.Weight(adjacentEdges(k));
                ek = G.ek(node,k);
                if k == 1
                    robin = c*w*ek*D1matrix + c*alpha(node)*ek;
                else
                    robin = robin + c*w*ek*D1matrix;
                end
            end
        end
        
    end