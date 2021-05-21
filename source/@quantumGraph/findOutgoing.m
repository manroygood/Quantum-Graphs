function outgoing = GCfindOutgoing(G,j)
% A simple to find all outgoing edges at node j
sz = 1;
outgoing = [];

for i = 1:size(G.Edges,1)
    if j == G.EndNodes(i,1) 
        suc = G.EndNodes(i,2);
        for k = 1:size(G.Edges,1)
            if j == G.EndNodes(k,1) && suc == G.EndNodes(k,2)
                outgoing(sz,1) = k;
                sz = sz+1;
            end
        end
    end
end

end