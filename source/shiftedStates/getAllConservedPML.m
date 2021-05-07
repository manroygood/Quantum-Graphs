function [P,E,L2]=getAllConservedPML(U,G,dPML)

nT=size(U,2);

P=zeros(nT,1);
E=zeros(nT,1);
L2=zeros(nT,1);

for k=1:nT
   G.column2graph(U(:,k));
   P(k)=getMomentumPML(G,dPML);
   E(k)=getEnergyPML(G,dPML);
   L2(k)=getL2NormPML(G,dPML);
end