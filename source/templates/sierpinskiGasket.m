function Phi = sierpinskiGasket(opts)

arguments
    opts.N=1;
    opts.robinCoeff=0;
    opts.nX=20;
    opts.Discretization='Uniform';
end
N = opts.N;

G=digraph([1 2 3],[2 3 1]);
x= [0;1;1/2] + 1i* [0; 0; sqrt(3)/2]; x = x-mean(x);
G.Nodes.x = x;

topTriangle=[1 2 3];
G=subdivide(G,topTriangle,N);

nodes=[real(G.Nodes.x) imag(G.Nodes.x)];
st=G.Edges.EndNodes;
source=st(:,1);
target=st(:,2);

L=2^(-N);
Phi = quantumGraph(source,target,L,...
    'nxVec',opts.nX,'robinCoeff',opts.robinCoeff,...
    'Discretization',opts.Discretization);
plotCoordFcn=@(G)plotCoordFcnFromNodes(G,nodes);
Phi.addPlotCoords(plotCoordFcn);

end

function H=subdivide(G,top,N)


if N > 0
    topplus=[top top(1)];
    nn = G.numnodes;
    %nedge = G.numedges;
    % Calculate the midpoints of the triangle's edges
    x= G.Nodes.x(topplus);
    xa = (x(1:end-1)+x(2:end))/2;
    %    G.Nodes.x1(nn+1:nn+3)=x1mid;
    %    G.Nodes.x2(nn+1:nn+3)=x2mid;
    nodeProps=table(xa,'VariableNames',{'x'});
    H=G.addnode(nodeProps);
    for i = 1:3
        thisedge=H.findedge(topplus(i),topplus(i+1));
        if ~thisedge
            thisedge=H.findedge(topplus(i+1),topplus(i));
        end
        H=H.rmedge(thisedge);
        H=H.addedge(topplus(i),nn+i);
        H=H.addedge(nn+i,topplus(i+1));
    end
    H = H.addedge(nn+1,nn+2);
    H = H.addedge(nn+2,nn+3);
    H = H.addedge(nn+3,nn+1);
    H=subdivide(H,[nn+1 top(2) nn+2],N-1);
    H=subdivide(H,[nn+2 top(3) nn+3],N-1);
    H=subdivide(H,[nn+3 top(1) nn+1],N-1);
else
    H=G;
end
end