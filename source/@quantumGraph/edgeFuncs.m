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


function incoming = GCfindIncoming(G,j)
% A simple command to find all incoming edges at node j
sz=1;
incoming = [];

for i = 1:size(G.EndNodes,1)
    if j == G.EndNodes(i,2)
        pred = G.EndNodes(i,1);
        for k = 1:size(G.Edges,1)
            if j == G.EndNodes(k,2) && pred == G.EndNodes(k,1)
                incoming(sz,1) = k;
                sz = sz+1;
            end
        end
    end
end

end