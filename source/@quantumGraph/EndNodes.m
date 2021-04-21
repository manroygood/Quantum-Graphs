function varargout = EndNodes(Phi,varargin)
% Returns the end nodes
% If one output argument, returns an nnodes*2 matrix
% If two output arguments, returns 2 nnodes*1 matrices
Edges=Phi.Edges;
if nargin ==1
    EN = Edges.EndNodes;
elseif nargin==2
    EN = Edges.EndNodes(varargin{1},:);
elseif nargin ==3
    EN = Edges.EndNodes(varargin{1},varargin{2});
end
if nargout==1
    varargout{1}=EN;
elseif nargout==2
    varargout{1}=EN(:,1);
    varargout{2}=EN(:,2);
end
end