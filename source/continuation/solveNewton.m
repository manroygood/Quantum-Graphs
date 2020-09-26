%% The Newton Solver
function [U,errorU,iterations]=solveNewton(U,myFunction,myMatrix,errorMax,options)
R=-myFunction(U);
errorU=max(abs(R(:)));
iterations=0;

while errorU>= errorMax
    [R,U,errorU]=newtonStep(R,U,myFunction,myMatrix);
    iterations=iterations+1;
end
if exist('options','var') && options.verboseFlag
    fprintf('%i iterations.\n',iterations)
end

%% The Newton step
function [R,U,error]=newtonStep(R,U,myFunction,myMatrix)
%[DU,flag]=bicgstab(A,R,[],[],precond); %#ok<ASGLU>
M = myMatrix(U);
DU=M\R;
U=U+DU;
R=-myFunction(U);
error=max(abs(R(:)));