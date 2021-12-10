%% The Newton Solver
function [U,errorU,iterations]=solveNewton(U,myFunction,myMatrix,errorMax,options)
R=-myFunction(U);
errorU=max(abs(R(:)));
iterations=0;
if ~exist('options','var')
    options.verboseFlag = false;
end

while errorU>= errorMax
    [R,U,errorU]=newtonStep(R,U,myFunction,myMatrix,options);
    iterations=iterations+1;
end
if exist('options','var') && options.verboseFlag
    fprintf('%i iterations.\n',iterations)
end

%% The Newton step
function [R,U,error]=newtonStep(R,U,myFunction,myMatrix,options)
M = myMatrix(U);
DU=M\R;
U=U+DU;
R=-myFunction(U);
error=max(abs(R(:)));
if exist('options','var') && options.verboseFlag
    figure;
    subplot(2,1,1);plot(U);
    subplot(2,1,2);plot(R);
    pause
end