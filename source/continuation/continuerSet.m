function options=continuerSet(optionsIn,varargin)

if nargin==0
    optionsIn=[];
end

% Set the default value of each field either to its value in optionsIn or
% to the rightmost value in the parentheses
defaultMaxTheta=setDefault(optionsIn,'maxTheta',3);
defaultBeta=setDefault(optionsIn,'beta',0.1);
defaultNThresh=setDefault(optionsIn,'NThresh',4);
defaultLambdaThresh=setDefault(optionsIn,'LambdaThresh',-1);
defaultSaveFlag=setDefault(optionsIn,'saveFlag',true);
defaultPlotFlag=setDefault(optionsIn,'plotFlag',true);
defaultVerboseFlag=setDefault(optionsIn,'verboseFlag',false);

% Define some tests for input validity
validPosNum = @(x) isnumeric(x) && x > 0;
validRealNum = @(x) isnumeric(x) && isreal(x);
validLogical = @(x) islogical(x) || (isnumeric(x) && (x==0 || x==1));
validOptions = @(x) isstruct(x) || isempty(x);

p=inputParser;
addRequired(p,'optionsIn',validOptions);
addParameter(p,'maxTheta',defaultMaxTheta,validPosNum);
addParameter(p,'beta',defaultBeta,validPosNum);
addParameter(p,'NThresh',defaultNThresh,validPosNum);
addParameter(p,'LambdaThresh',defaultLambdaThresh,validRealNum);
addParameter(p,'saveFlag',defaultSaveFlag,validLogical);
addParameter(p,'plotFlag',defaultPlotFlag,validLogical);
addParameter(p,'verboseFlag',defaultVerboseFlag,validLogical);

parse(p,optionsIn,varargin{:});

options=p.Results;
options=rmfield(options,'optionsIn');

end

function defaultValue=setDefault(testStruct,field,value)
if ~isempty(testStruct) && isfield(testStruct,field)
    defaultValue = getfield(testStruct,field);
else
    defaultValue =value;
end
end