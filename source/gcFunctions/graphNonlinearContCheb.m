function [NVec,LambdaVec,bifTypeVec]= ...
    graphNonlinearContCheb(Phi,fcns,outputDir,PhiColumn,Lambda0,LambdaThresh,NThresh,beta,maxTheta,direction,saveFlag,plotFlag)

x=1:length(PhiColumn);
NVec=zeros(2,1);
LambdaVec=zeros(2,1);
bifTypeVec=zeros(2,1);

dotProduct.dot=@(Phi1,Phi2) GCchebdot(Phi,Phi1,Phi2);
dotProduct.beta=beta; 
dotProduct.big=@(Phi1,Phi2,w1,w2) (dotProduct.dot(Phi1,Phi2)+beta*w1*w2);

ds=0.01; params.vContract=.75; params.maxCount=4; params.maxTheta=maxTheta; % SHRINK ds TO SHRINK THETA STEP

if plotFlag; plot(x,PhiColumn,'color',randomColor); end
if saveFlag; saveToDir(PhiColumn,outputDir,1); end

NVec(1)=dotProduct.dot(PhiColumn,PhiColumn);
LambdaVec(1)=Lambda0;

PhiColOld=PhiColumn;
LambdaOld=Lambda0;
tauOld=nan;

jmax=10; dsfactor=0.7; % constants used to reduce stepsize if the Newton solver fails to find a solution

% the second solution on the branch. Assume no bifurcations between first
% and second solutions
params.direction=1;
[PhiColumn,LambdaVec(2),~]=graphContinuer(fcns,ds,PhiColOld,LambdaOld,dotProduct,params.direction,[],[]);
NVec(2)=dotProduct.dot(PhiColumn,PhiColumn);
% Assumes that we are looking for direction*Lambda to be initially increasing along the
% computed branch of solutions
if direction*(LambdaVec(2)-LambdaVec(1))>0
    params.direction=-params.direction;
    [PhiColumn,LambdaVec(2),tauOld]=graphContinuer(fcns,ds,PhiColOld,LambdaOld,dotProduct,params.direction,[],[]);
    NVec(2)=dotProduct.dot(PhiColumn,PhiColumn);
end
if plotFlag; plot(x,PhiColumn,'color',randomColor); end
if saveFlag; saveToDir(PhiColumn,outputDir,2); end

% calculate subsequent solutions on the branch
k=2;
LambdaOld=LambdaVec(1);Lambda=LambdaVec(2);
while ~crossThresh(LambdaThresh,LambdaVec,k) && ~crossThresh(NThresh,NVec,k)
    if k == length(NVec)
        if saveFlag;saveFilesToDir(outputDir,NVec,LambdaVec,bifTypeVec);end
        [NVec,LambdaVec]=extendAll(10,NVec,LambdaVec,bifTypeVec);
    end
    k=k+1;
    success = false; j=0; 
    while ~success
        [PhiColumn,PhiColOld,Lambda,LambdaOld,ds,k,success,tau] = ...
            nextGraphSolution(fcns,dotProduct,PhiColumn,PhiColOld,Lambda,LambdaOld,ds,k,params);
        j=j+1; ds = ds*dsfactor;
        assert(j<=jmax,'nextGraphSolution failed!')
    end
    if tau*tauOld<0  % bifurcation detected
        [PhiBif,LambdaBif,bifType] = graphBifurcationDetectorCheb(fcns,PhiColumn,Lambda);
        fprintf('at step %i.\n',k);
        if bifType==1 && saveFlag
            outputNewDirection(fcns,PhiBif,LambdaBif,PhiColumn,outputDir,k,dotProduct,ds);
        end
        NVec(k)=dotProduct.dot(PhiBif,PhiBif);
        NVec(k+1)=dotProduct.dot(PhiColumn,PhiColumn);
        
        LambdaVec(k)=LambdaBif;
        LambdaVec(k+1)=Lambda;
        bifTypeVec(k)=bifType;
        bifTypeVec(k+1)=0;
        
        if saveFlag
            PhiTemp=PhiColumn;
            PhiColumn=PhiBif; saveToDir(PhiColumn,outputDir,k);
            PhiColumn=PhiTemp; saveToDir(PhiColumn,outputDir,k+1);
        end
        k=k+1;
        if plotFlag
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
        LambdaVec(k)=Lambda;
        bifTypeVec(k)=0;
        if plotFlag
            figure(1)
            plot(x,PhiColumn,'color',randomColor);
            figure(2);plot(LambdaVec(1:k),NVec(1:k));pause(.1)
        end
        if saveFlag; saveToDir(PhiColumn,outputDir,k); end
    end
    tauOld=tau;
end

if crossThresh(LambdaThresh,LambdaVec,k)
    fprintf('Lambda threshold crossed.\n')
elseif crossThresh(NThresh,NVec,k)
    fprintf('N threshold crossed.\n')
end
if k<length(NVec); NVec=NVec(1:k); LambdaVec=LambdaVec(1:k); bifTypeVec=bifTypeVec(1:k); end
if plotFlag
    figure(2);clf;plot(LambdaVec,NVec);
    xlabel('\Lambda');ylabel('Q_0');
    hold on
    folds=find(bifTypeVec==1);branches=find(bifTypeVec==-1);
    plot(LambdaVec(folds),NVec(folds),'ro',LambdaVec(branches),NVec(branches),'b*')
end
if saveFlag; saveFilesToDir(outputDir,NVec,LambdaVec,bifTypeVec); end