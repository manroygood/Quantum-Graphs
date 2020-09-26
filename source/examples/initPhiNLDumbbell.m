function Phi=initPhiNLDumbbell(Phi,Lambda0,edges,signs)
% Finds a large-amplitude standing wave with frequency Lambda0 
%
% It looks for a solution which looks like a sum of sech functions which
% are located at the centers of the edges specificied in the input argument
% "edges" and which have signs specified by the input argument "signs"


sL=sqrt(abs(Lambda0));
L2 = Phi.L(2)/2;
L3  = Phi.L(3)/2;

x1=Phi.x{1};
x2=Phi.x{2};

x1=-L2-L3 +abs(x1-L3);
x2=x2-L2;
x3=-x1;
x=[x1;x2;x3];

y=zeros(size(x));
x0 = (-1:1)*(L2+L3);
for k=1:length(edges)
    y = y+signs(k)*sL*sech(sL*(x-x0(edges(k))));
end

M=Phi.laplacianMatrix;
fcns=getGraphFcns(M);
myF=@(z) fcns.f(z,Lambda0);
myMatrix = @(u) fcns.fLinMatrix(u,Lambda0);
initTol=1e-6;
[y,~,~]=solveNewton(y,myF,myMatrix,initTol);
Phi.column2graph(y);