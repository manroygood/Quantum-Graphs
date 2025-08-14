function [y,g] =lassoExactStanding(Phi,Lambda,n,which)

assert(exist('mJacobiAM.m','file'),...
    'This routine depends on the package elfun18 from the MATLAB File Exchange')
if strcmp(which,'cnsymm')
    k = kcn(Lambda,n);
    K = EllipticK(k);
    b = sqrt(Lambda/(1-2*k^2));
    a = k*b;
    g1 = @(x)a*JacobiCN(b*x-K,k);
    g2 = 0;

elseif strcmp(which,'cnasymm')
    assert(Lambda<0,'Lambda must be negative for the cnasymm solution')
    Omega = sqrt(-Lambda);
    k = kcn(Lambda,n);
    b = sqrt(Lambda/(1-2*k^2));
    a = k*b;
    K = EllipticK(k);
    xfcn = @(x0)1-JacobiCN(b*x0-K,k)*k/sqrt(2*k^2-1);
    x0 = fzero(xfcn,[0 K/n/b]);
    g1 = @(x)a*JacobiCN(b*(x-x0)+K,k);
    g2 = @(x)Omega*sech(Omega*x);
elseif strcmp(which,'dn1')
    assert(Lambda<0,'Lambda must be negative for the dn1 solution')
    Omega = sqrt(-Lambda);
    fp = fplot(@(k)dnEqn1(Omega,k),[0 1]);
    kvec=fp.XData; fvec=fp.YData;
    signchanges=fvec.*circshift(fvec,[0 -1])<0;
    p=find(signchanges(1:end-1));
    assert(~isempty(p),'no roots found to equation dnEqn1');
    N = length(p);
    assert(N>0,'not enough roots found')
    spot = p(N+1-n); 
    k = fzero(@(k)dnEqn1(Omega,k),[kvec(spot) kvec(spot+1)]);
    plot(kvec,fvec,k,0,'o')
    b=Omega/sqrt(2-k^2);
    g1=@(x) JacobiDN(b*(x-pi),k)*Omega/sqrt(2-k^2);
    s = sign(JacobiSN(-b*pi,k)*JacobiCN(-b*pi,k));
    x0 = s*asech(JacobiDN(b*pi,k)/sqrt(2-k^2))/Omega;
    g2=@(x)Omega*sech(Omega*(x-x0));

elseif strcmp(which,'dn2')
    assert(Lambda<0,'Lambda must be negative for the dn2 solution')
    Omega = sqrt(-Lambda);
    fp = fplot(@(k)dnEqn2(Omega,k),[0 1]);
    kvec=fp.XData; fvec=fp.YData;
    signchanges=fvec.*circshift(fvec,[0 -1])<0;
    p=find(signchanges(1:end-1));
    assert(~isempty(p),'no roots found to equation dnEqn1');
    N = length(p);
    assert(N>0,'not enough roots found')
    spot = p(N+1-n); 
    k = fzero(@(k)dnEqn2(Omega,k),[kvec(spot) kvec(spot+1)]);
    plot(kvec,fvec,k,0,'o')    
    b=Omega/sqrt(2-k^2);
    g1=@(x) JacobiND(b*(x-pi),k)*b*sqrt(1-k^2);
    s= sign(JacobiCD(-b*pi,k)*JacobiSD(b*pi,k));
    x0 = s*asech(sqrt((1-k^2)/(2-k^2))*JacobiND(b*pi,k))/Omega;
    g2=@(x)Omega*sech(Omega*(x-x0));

else
    error('which must be cnsymm cnasymm dn1 or dn2')
end
g = {g1,g2};

y = Phi.applyFunctionsToAllEdges(g);

end

function k = kcn(Lambda,n)

f=@(k) 4*n^2/pi^2*(1-2*k^2)*EllipticK(k)^2-Lambda;
eps=1e-8;
if Lambda<0
    k = fzero(f,[1/sqrt(2)+eps 1-eps]);
elseif Lambda>0
    k = fzero(f,[eps 1/sqrt(2-eps)]);
else
    k = 1/sqrt(2);
end

end

function y = dnEqn1(Omega,k)
b = pi*Omega./sqrt(2-k.^2);
z = JacobiCN(b,k);
y = -1 + k.^2.*(1+3*k.^2.*z.^2.*(1-z.^2));
end

function y = dnEqn2(Omega,k)
b = pi*Omega./sqrt(2-k.^2);
z = JacobiDN(b,k);
y = 3 -3*k.^2 + z.^2.*(-6+3*k.^2+4*z.^2);
end