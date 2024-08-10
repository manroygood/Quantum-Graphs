function [NVec,LambdaVec,energyVec,bifTypeVec,bifLocs]= ...
    graphNonlinearCont(Phi,fcns,outputDir,PhiColumn,Lambda0,direction,options,PhiColumnOld,LambdaOld)
% If the continuer options are unset, use the defaults
if ~exist('options','var')
    options=continuerSet;
end

testPhi = exist('PhiColumnOld','var');
testLambda = exist('LambdaOld','var');

assert( (testPhi&&testLambda) || (~testPhi&&~testLambda),...
    'Either both or neither of PhiColumnOld and LambdaOld must be defined')



dotProduct.dot=@(Phi1,Phi2) Phi.dot(Phi1,Phi2);
dotProduct.beta=options.beta;
dotProduct.big=@(Phi1,Phi2,w1,w2) (dotProduct.dot(Phi1,Phi2)+options.beta*w1*w2);

ds=0.01;params.vContract=.8;params.maxCount=4;params.maxTheta=options.maxTheta;


k=1;

x=1:length(PhiColumn);
n0=2+int8(testPhi);
NVec=zeros(n0,1);
LambdaVec=zeros(n0,1);
energyVec=zeros(n0,1);
bifTypeVec=zeros(n0,1);

if testPhi
    NVec(k)=dotProduct.dot(PhiColumnOld,PhiColumnOld);
    LambdaVec(k)=LambdaOld;
    energyVec(k)=energyNLS(Phi,PhiColumnOld,fcns);
    if options.plotFlag; plot(x,PhiColumnOld,'color',randomColor); end
    if options.saveFlag; PhiTemp=PhiColumn;PhiColumn=PhiColumnOld;saveToDir(PhiColumn,outputDir,k); PhiColumn=PhiTemp;end
    k=k+1;
end


NVec(k)=dotProduct.dot(PhiColumn,PhiColumn);
LambdaVec(k)=Lambda0;
energyVec(k)=energyNLS(Phi,PhiColumn,fcns);

if options.plotFlag; plot(x,PhiColumn,'color',randomColor); end
if options.saveFlag; saveToDir(PhiColumn,outputDir,k); end

PhiColOld=PhiColumn;
LambdaOld=Lambda0;
tauOld=nan;

jmax=10; dsfactor=params.vContract; % constants used to reduce stepsize if the Newton solver fails to find a solution

% the second solution on the branch. Assume no bifurcations between first
% and second solutions
params.direction=1;
k=k+1;
[PhiColumn,LambdaVec(k),~]=graphContinuer(fcns,ds,PhiColOld,LambdaOld,dotProduct,params.direction,[],[]);
NVec(k)=dotProduct.dot(PhiColumn,PhiColumn);
energyVec(k)=energyNLS(Phi,PhiColumn,fcns);
% Assumes that we are looking for direction*Lambda to be initially increasing along the
% computed branch of solutions
if direction*(LambdaVec(k)-LambdaVec(k-1))>0
    params.direction=-params.direction;
    [PhiColumn,LambdaVec(k),tauOld]=graphContinuer(fcns,ds,PhiColOld,LambdaOld,dotProduct,params.direction,[],[]);
    NVec(k)=dotProduct.dot(PhiColumn,PhiColumn);
    energyVec(k)=energyNLS(Phi,PhiColumn,fcns);
end
if options.plotFlag; plot(x,PhiColumn,'color',randomColor); end
if options.saveFlag; saveToDir(PhiColumn,outputDir,k); end

normDelta=1; % Fake value so as not to trip up the
% calculate subsequent solutions on the branch

LambdaOld=LambdaVec(k-1);Lambda=LambdaVec(k);
while ~crossThresh(options.LambdaThresh,LambdaVec,k) ...
        && ~crossThresh(options.NThresh,NVec,k) ...
        && normDelta > options.minNormDelta ...
        && k <= options.maxPoints
    if k == length(NVec)
        if options.saveFlag;saveFilesToDir(outputDir,NVec,LambdaVec,energyVec,bifTypeVec);end
        [NVec,LambdaVec,energyVec,bifTypeVec]=extendAll(10,NVec,LambdaVec,energyVec,bifTypeVec);
    end
    k=k+1;
    success = false; j=0;
    while ~success
        [PhiColumn,PhiColOld,Lambda,LambdaOld,ds,k,success,tau] = ...
            nextGraphSolution(fcns,dotProduct,PhiColumn,PhiColOld,Lambda,LambdaOld,ds,k,params,options);
        j=j+1; ds = ds*dsfactor;
        assert(j<=jmax,'nextGraphSolution failed!')
    end
    normDelta=max(Phi.norm(PhiColumn-PhiColOld),abs(Lambda-LambdaOld));
    if tau*tauOld<0  % bifurcation detected
        [PhiBif,LambdaBif,bifType]=graphBifurcationDetector(fcns,PhiColumn,Lambda,options);
        if options.verboseFlag; fprintf('at step %i.\n',k);end
        if bifType==1 && options.saveFlag
            outputNewDirection(fcns,PhiBif,LambdaBif,PhiColumn,outputDir,k,dotProduct,ds);
        end
        NVec(k)=dotProduct.dot(PhiBif,PhiBif);
        NVec(k+1)=dotProduct.dot(PhiColumn,PhiColumn);
        energyVec(k)=energyNLS(Phi,PhiBif,fcns);
        energyVec(k+1)=energyNLS(Phi,PhiColumn,fcns);

        LambdaVec(k)=LambdaBif;
        LambdaVec(k+1)=Lambda;
        bifTypeVec(k)=bifType;
        bifTypeVec(k+1)=0;

        if options.saveFlag
            PhiTemp=PhiColumn;
            PhiColumn=PhiBif; saveToDir(PhiColumn,outputDir,k);
            PhiColumn=PhiTemp; saveToDir(PhiColumn,outputDir,k+1);
        end
        k=k+1;
        if options.plotFlag
            figure(1)
            plot(x,PhiColumn,'color',randomColor);
            if bifType==1
                plot(x,PhiBif,'r--','linewidth',2)
            else
                plot(x,PhiBif,'k--','linewidth',2)
            end
            figure(2);plot(LambdaVec(1:k),NVec(1:k));pause(.1)
        end
    else
        NVec(k)=dotProduct.dot(PhiColumn,PhiColumn);
        energyVec(k)=energyNLS(Phi,PhiColumn,fcns);
        LambdaVec(k)=Lambda;
        bifTypeVec(k)=0;
        if options.plotFlag
            figure(1)
            plot(x,PhiColumn,'color',randomColor);
            figure(2);plot(LambdaVec(1:k),NVec(1:k));pause(.1)
        end
        if options.saveFlag; saveToDir(PhiColumn,outputDir,k); end
    end
    tauOld=tau;
    % This allows the user to exit with Ctrl-C without leading to an error
    cleanupObj = onCleanup(@()cleanMeUp(options,outputDir,NVec,LambdaVec,bifTypeVec,k));
end

if crossThresh(options.LambdaThresh,LambdaVec,k)
    fprintf('Lambda threshold %0.1f crossed.\n',options.LambdaThresh)
elseif crossThresh(options.NThresh,NVec,k)
    fprintf('N threshold %0.1f crossed.\n',options.NThresh)
elseif k > options.maxPoints
    fprintf('Maximum number of points on curve exceeded. Change maxPoints if needed.\n')
elseif normDelta<options.minNormDelta
    fprintf('Exited because distance between successive solutions below threshold.\n')
end
if k<length(NVec); NVec=NVec(1:k); LambdaVec=LambdaVec(1:k);  bifTypeVec=bifTypeVec(1:k); energyVec=energyVec(1:k);end
if options.plotFlag
    figure(2);clf;plot(LambdaVec,NVec);
    xlabel('$\Lambda$');ylabel('$Q_0$');
    hold on
    folds=find(bifTypeVec==1);branches=find(bifTypeVec==-1);
    plot(LambdaVec(folds),NVec(folds),'ro',LambdaVec(branches),NVec(branches),'b*')
end
if options.saveFlag; saveFilesToDir(outputDir,NVec,LambdaVec,energyVec,bifTypeVec,k); end
bifLocs=find(bifTypeVec==1);
end

% This function tells MATLAB to cleanup and output stuff one last time
% if the user hits ctrl-C
function cleanMeUp(options,outputDir,NVec,LambdaVec,bifTypeVec,k)
if options.saveFlag
    NVec=NVec(1:k); LambdaVec=LambdaVec(1:k);bifTypeVec=bifTypeVec(1:k);
    saveFilesToDir(outputDir,NVec,LambdaVec,bifTypeVec,k);
end
end