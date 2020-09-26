function [v1,v2]=tribellResolveDoubles(V,k,N1,N2)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on tribell
% graph in order to display that these eigenfunctions are identically zero
% on some edges
V1=V(:,k);
V2=tribellShift(V1,N1,N2);
v1= V1*V2(1)-V2*V1(1); v1=v1/max(v1);
v2=tribellShift(V1,N1,N2);