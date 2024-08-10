function count = countUnboundedEdges(G)
count = sum(isinf(G.L));