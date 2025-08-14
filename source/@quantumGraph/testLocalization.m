function flag=testLocalization(G,y)

G.column2graph(y);
assert(~G.isCompact,'Compact graph. The question of localization is moot.')

eps_test = 1e-4;
flag = true;
for k=1:G.numedges
    L= G.L(k);
    if isinf(L)
        xx = G.x{k};
        j = find(xx>0.9*xx(end),1,'first');
        xx = xx(j:end);
        yy = G.y{k}; yy = yy(j:end);
        p = polyfit(xx-xx(end),yy,1);
        if abs(p(1))>eps_test
            flag= false;
            return;
        end
    end
end