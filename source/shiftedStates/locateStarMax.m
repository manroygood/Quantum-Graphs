function [edgeNum,xMax]=locateStarMax(U,G)
[~,nxC,~]=G.nx;
[~,p]=max(abs(U));
edgeNum=find(p>nxC,1,'last');
xspot=p-nxC(edgeNum);
x=G.Edges.x{edgeNum}; xMax=x(xspot);
