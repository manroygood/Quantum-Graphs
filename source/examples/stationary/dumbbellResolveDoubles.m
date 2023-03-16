function vv=dumbbellResolveDoubles(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on dumbell
% graph in order to display that these eigenfunctions are identically zero
% on some edges

% Technical note: the function eigenfunctionsSaveData.m requires the double
% eigenvalue resolution program to take three arguments V, k, and Phi.
% For the dumbbell graph, we don't need Phi to calculate the resolved
% eigenfunctions, so we use the ~ placeholder.
V1=V(:,k);
V2=flip(V1);
[~,p]=max(abs(V1));
v1= V1*V2(p)-V2*V1(p); v1=v1/Phi.norm(v1);
v2= flip(v1);
vv{1}=v1;
vv{2}=v2;