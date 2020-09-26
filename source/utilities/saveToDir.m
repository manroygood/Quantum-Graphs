function saveToDir(x,directory,n)

global nLabel
if ~exist(directory,'dir')
    mkdir(directory)
end

if nargin<3
    filename=inputname(1);
else
    filename=[inputname(1) '.' get_label(n,nLabel)];
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