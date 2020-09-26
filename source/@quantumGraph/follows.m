function flag = follows(G,j,jprime) % true if edge jprime follows edge j
flag=false;
n=numedges(G);
if j<=n && jprime <=n
    if G.EndNodes(j,2)==G.EndNodes(jprime,1)
        flag=true;
    end
elseif j<=n && jprime >n
    if G.EndNodes(j,2)==G.EndNodes(jprime-n,2)
        flag=true;
    end
elseif j>n && jprime <=n
    if G.EndNodes(j-n,1)==G.EndNodes(jprime,1)
        flag=true;
    end
elseif j>n && jprime >n
    if G.EndNodes(j-n,1)==G.EndNodes(jprime-n,2)
        flag=true;
    end
end
end