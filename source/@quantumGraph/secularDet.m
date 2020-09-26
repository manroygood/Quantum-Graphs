function f = secularDet(G)
L=sym(G.L);
n=numedges(G);
S=sym(zeros(2*n));
D=sym(zeros(2*n));
Eye=sym(eye(2*n));
%syms(sym('k'))
k=sym('k');
for j=1:n
    entry=exp(1i*L(j)*k);
    D(j,j)=entry;
    D(j+n,j+n)=entry;
end

for j=1:2*n
    if j<=n
        jbar=j+n;
        dv=fullDegreeEtc(G,G.EndNodes(j,2));
    else
        jbar=j-n;
        dv=fullDegreeEtc(G,G.EndNodes(j-n,1));
    end
    
    for jprime =1:2*n
        if jprime==jbar
            S(jprime,j)=2/dv-1;
        elseif G.follows(j,jprime)
            S(jprime,j)=2/dv;
        end
    end
end
LL=sum(L);
SS=sqrt(det(S));

f=det(Eye-S*D)*exp(-1i*k*LL)/SS;
f=rewrite(f,'sin');
f=simplify(f);
f=prod(factor(f));
end


