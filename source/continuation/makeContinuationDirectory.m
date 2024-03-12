function dataDir = makeContinuationDirectory(Phi,tag,verbose)
if ~exist('verbose','var'); verbose = false; end

diagramNumber=incrementRunNumber(tag);
dataDir=createDataDirectories(tag,diagramNumber);

%% Plot the graph layout
close all;
if verbose; Phi.plot('mutelayout'); end

%% Save the template to a file
filename=fullfile(dataDir,'template');
save(filename,'Phi');

%% Save a comment file
% Just sets it up. doesn't do anything with it
filename=fullfile(dataDir,'logfile.txt');
fid=fopen(filename,'w');
fprintf(fid,'Log file for directory %s.\n',dataDir);
fprintf(fid,'Discretization: %s.\n',Phi.discretization);
fprintf(fid,'-------------------------------------------------------\n');
fclose(fid);

fprintf('Created directory %s.\n',dataDir)
