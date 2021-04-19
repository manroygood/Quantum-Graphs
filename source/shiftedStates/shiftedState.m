function Phi0vector=shiftedState(Phi,x0,v0)
% Note that this assigns the shifted state to the graph Phi
fIncoming = @(x)sech(x-x0).*exp(1i*v0*(x-x0)/2);
Phi.applyFunctionToEdge(fIncoming,1);
%Phi.qg.Edges.y{1}=fIncoming(Phi.x{1});

fOutgoing = @(x)sech(x+x0).*exp(-1i*v0*(x+x0)/2);
for j=2:numedges(Phi)
    Phi.applyFunctionToEdge(fOutgoing,j);
    %Phi.qg.Edges.y{j}=fOutgoing(Phi.x{j});
end

Phi0vector=Phi.graph2column;