function saveOptionsToLog(dataDir,options) %#ok<INUSD> 
myString= sprintf('\nRun with options\n%s', evalc('disp(options)'));
addComment(dataDir,myString);