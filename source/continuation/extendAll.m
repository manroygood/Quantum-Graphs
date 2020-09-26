    function varargout=extendAll(nK,varargin)
        n=nargin-1;
        varargout=cell(n,1);
        for j=1:n
            varargout{j}=extend(varargin{j},nK);
        end
    end

    function y = extend(x,nK)
        y=[x;nan(nK,1)];
    end