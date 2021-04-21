function saveToDir(x,directory,n)

if ~exist(directory,'dir')
    mkdir(directory)
end

if nargin<3
    filename=inputname(1);
else
    filename=[inputname(1) '.' getLabel(n)];
end

if ischar(x)
    filename=fullfile(directory,filename);
    fid=fopen(filename,'w+');
    fprintf(fid,'%s\n',x);
    fclose(fid);
elseif iscell(x)
    save(filename,'x')
else
    if ~isreal(x)
        x=[real(x) imag(x)];
    end
    
    save(fullfile(directory,filename),'x','-ascii','-double')
end