function [UNew,U,muNew,mu,ds,j,success,tau]= ...
    nextGraphSolution(fcns,dotProduct,U,UOld,mu,muOld,ds,j,params,options)

dU=U-UOld; dmu = mu-muOld;
reduceFactor=0.9;

% Find a point on the curve
[UNew,muNew,tau] = ...
    graphContinuer(fcns,ds,U,mu,dotProduct,params.direction,dU,dmu);

% Test if the angle it makes with the previous two points is below the
% threshold. If it isn't, reduce ds and try again, until maxCount reached
theta=getAngle(UNew,U,UOld,muNew,mu,muOld,dotProduct); 
count=1;
while theta>params.maxTheta && count< params.maxCount
    ds=ds*params.vContract;
    [UNew,muNew,tau]=...
        graphContinuer(fcns,ds,U,mu,dotProduct,params.direction,dU,dmu);
    theta=getAngle(UNew,U,UOld,muNew,mu,muOld,dotProduct); 
    count=count+1;
end

% if succeeded in fewer than maxCount steps, adjust stepsize, declare it a
% success and then exit
if count<params.maxCount
    ds=ds*reduceFactor*params.maxTheta/theta;
    success=true;
    if options.verboseFlag
        fprintf('ds = %f, Theta = %f\n',ds,theta);
    end
else % back up a step
    j=j-1;
    [UNew,muNew,tau] = ...
        graphContinuer(fcns,ds,UOld,muOld,dotProduct,params.direction,dU,dmu);
    U=UOld;mu=muOld;
    success=false;
    if options.verboseFlag
        fprintf('Failure! ds = %f, Theta = %f\n', ds,theta)
    end
end