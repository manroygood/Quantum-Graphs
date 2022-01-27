function Gnew=rmnode(G,nodeIDs)

Gnew = G;
Gnew.qg = G.qg.rmnode(nodeIDs);