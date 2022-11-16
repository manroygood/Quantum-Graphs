function x=allZeros(f,interval)
xx = linspace(interval(1),interval(2),1001);
f = matlabFunction(f);
ff= f(xx);
signChanges = find(ff(1:end-1).*ff(2:end)<0);
nx = length(signChanges);
if nx ==0
    x=[];
    return
end

x = zeros(nx,1);
for k=1:nx
    xguess=xx(signChanges(k));
    x(k)=fzero(f,xguess);
end