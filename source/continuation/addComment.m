function addComment(dataDir,varargin)
% Adds the input line to the logfile in dataDir. 
% If no second input, then adds a line of dashes to the logfile
filename=fullfile(dataDir,'logfile.txt');
fid=fopen(filename,'a');
if nargin==1
    fprintf(fid,'-------------------------------------------------------');
else
    fprintf(fid,varargin{:});
end
fprintf(fid,'\n');
fclose(fid);