function vv=dumbbellResolveDoubles(V,k,Phi)
% Recombines the eigenfunctions of multiplicity-two eigenvalues on dumbell
% graph in order to display that these eigenfunctions are identically zero
% on some edges

% Technical note: the function eigenfunctionsSaveData.m requires the double
% eigenvalue resolution program to take three arguments V, k, and Phi.
% For the dumbbell graph, we don't need Phi to calculate the resolved
% eigenfunctions, so we use the ~ placeholder.

if Phi.isUniform
    V1=V(:,k);
    V2=flip(V1);
    v1= V1*V2(1)-V2*V1(1); v1=v1/Phi.norm(v1);
    v2= flip(v1);
    vv{1}=v1;
    vv{2}=v2;
else
    [~,nxC,~]=Phi.nx;
    V1=V(:,k);
    V2=V(:,k+1);
    [~,i1] = max(V1(nxC(1)+1:nxC(2)));
    [~,i2] = max(V2(nxC(1)+1:nxC(2)));
    if i1 == i2
        v1 = (V1 + V2 * max(V1(nxC(3)+1:nxC(4)))/max(V2(nxC(3)+1:nxC(4))) )/2;
        v1 = v1/Phi.norm(v1);
        v2 = (V1 - V2 * max(V1(nxC(1)+1:nxC(2)))/max(V2(nxC(1)+1:nxC(2))) )/2;
        v2 = v2/Phi.norm(v2);
    else
        v1 = (V1 + V2 * max(V1(nxC(1)+1:nxC(2)))/max(V2(nxC(1)+1:nxC(2))) )/2;
        v1 = v1/Phi.norm(v1);
        v2 = (V1 - V2 * max(V1(nxC(3)+1:nxC(4)))/max(V2(nxC(3)+1:nxC(4))) )/2;
        v2 = v2/Phi.norm(v2);
    end
    vv{1} = v1;
    vv{2} = v2;
end