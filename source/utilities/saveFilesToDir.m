function saveFilesToDir(directory,varargin)

if ~exist(directory,'dir')
    mkdir(directory)
end

for k=2:nargin
    filename=inputname(k);
    x=varargin{k-1};
    filename=fullfile(directory,filename);
    
    if ischar(x)
        fid=fopen(filename,'w+');
        fprintf(fid,'%s\n',x);
        fclose(fid);
    elseif iscell(x)
        save(filename,'x')
    elseif islogical(x)
        x=double(x);
        save(filename,'x')
    elseif isstruct(x)
        save(filename,'x')
    else
        if ~isreal(x)
            x=[real(x) imag(x)]; %#ok<NASGU>
        end
        
        save(filename,'x','-ascii','-double')
    end
end