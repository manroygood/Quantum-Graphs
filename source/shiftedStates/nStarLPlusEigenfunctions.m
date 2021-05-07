%% nStar Laplacian program
% Computes the eigenvalues and eigenfunctions of the Lplus operator
% linearizing about shifted state
function GNew=nStarLPlusEigenfunctions(nEdges,p,x0,L,nx)

%% Set up the graph structure and coordinates of the problem
if x0==0; x0=.001; end
G=starQuantumGraph(nEdges,L,nx,[],true);
G=addNStarPlotCoords(G);
G0=shiftedState(G,x0,0,p);
%% Set up coordinates on which to plot the solutions
G=addNStarPlotCoords(G,L);
G0=addNStarPlotCoords(G0,L);
u0=graph2column(G0);
clf;plotOnGraph(G0);
%% Construct the operator Lplus and calculate its eigenvalues and eigenvectors
M = quantumGraphLaplacian(G);
LplusMat = Lplus(M,u0,p);
[V,d]=eig(full(LplusMat));
d=diag(d); 
[~,ord]=sort(d,'descend'); 
V=real(V(:,ord));
if x0>0
    nn=nEdges*nx-2;
else
    nn=nEdges*nx-1;
end
vPert=V(:,nn);
GNew=column2graph(vPert,G);
L2 = getL2Norm(GNew);
for j=1:nEdges
        GNew.Edges.y{j}=GNew.Edges.y{j}/L2;
end
GNew.Edges.y{1}=zeros(size(GNew.Edges.y{1}));
GNew.Edges.y{3}=-GNew.Edges.y{2};