function [v1,v2]=dumbbellResolveDoubles(V,k)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on dumbell
% graph in order to display that these eigenfunctions are identically zero
% on some edges
V1=V(:,k);
V2=flip(V1);
v1= V1*V2(1)-V2*V1(1); v1=v1/max(v1);
v2= flip(v1);