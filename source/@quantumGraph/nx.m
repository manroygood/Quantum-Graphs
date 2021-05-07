function [nxVec,nxC,nxTot]=nx(Phi,varargin)

% Returns the number of points in the mesh on the quantum graph Phi
if Phi.isUniform
    
    if nargin==1   
        nxVec=(Phi.Edges.nx);
        nxC=[0;cumsum(nxVec)];
        nxTot=nxC(end);
    else % if the second argument is a positive integer, return nx on that branch
        j = varargin{1};
        nxVec=(Phi.Edges.nx);
        nxVec=nxVec(j);
    end
    
else
    
    if nargin==1   
        nxVec=Phi.Edges.nx + 2*ones(size(Phi.Edges.nx));
        nxC=[0;cumsum(nxVec)];
        nxTot=nxC(end);
    else % if the second argument is a positive integer, return nx on that branch
        j = varargin{1};
        nxVec=(Phi.Edges.nx);
        nxVec=nxVec(j) + 2;
    end

end