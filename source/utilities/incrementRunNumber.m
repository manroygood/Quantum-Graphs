function runNumber=incrementRunNumber(tag,varargin)
% Maintain the count of times the program has run
if nargin==2
    numberfile=fullfile(varargin{1},['.' tag '_number']);
else
    numberfile=['.' tag '_number'];
end
if exist(numberfile,'file')
    runNumber=load(numberfile);
    runNumber=runNumber+1;
else
    runNumber=1;
end

fid=fopen(numberfile,'w');
fprintf(fid,'%i',runNumber);
fclose(fid);