function [xBif,muBif,bifType]=graphBifurcationDetector(fcns,x,mu,options)
Fkx=fcns.fLinMatrix(x,mu);

[u0,~]=eigs(Fkx,1,'smallestabs');

Fk = fcns.f(x,mu);
resid1  = norm(Fk);
resid2 = norm(Fkx*u0);
residual = resid1+resid2;

updateSize=1;
tol=1e-6;
maxTries=200;
tries=0;

xBif=x;
muBif=mu;
while residual>tol && updateSize>tol && tries < maxTries
    tries=tries+1;
    Fkmu = fcns.fMu(xBif,muBif);
    Fkxxu= fcns.fxxu(xBif,muBif,u0);
    Fkxmu = fcns.fxMu(xBif,muBif);
    
    z1 = Fkx\(-Fk);  % Nayfeh (6.2.8)
    z2 = Fkx\(-Fkmu);    % Nayfeh (6.2.7)
    
    rhs3 = -(Fkx*u0 + Fkxxu*z1);
    z3 = Fkx \ rhs3;   % Nayfeh (6.2.12)
    
    rhs4 = -(Fkxxu*z2 + Fkxmu*u0);
    z4 = Fkx \ rhs4;   % Nayfeh (6.2.11)
    
    % Then the corrections are:
    dMu = ( 1-dot(u0,u0+2*z3) ) / 2 / dot(u0,z4); % Nayfeh (6.2.14)
    dx = z1 + dMu*z2; % Nayfeh (6.2.9)
    du = z3 + dMu*z4; % Nayfeh (6.2.13)
    updateSize=abs(dMu)+norm(du)+norm(dx);
    
    % Which we apply
    xBif = xBif+dx;
    muBif = muBif+dMu;
    u0 = u0 + du;
    
    % Compute the residual and some terms needed at next Newton iterate
    Fk = fcns.f(xBif,muBif);
    Fkx=fcns.fLinMatrix(xBif,muBif);
    
    resid1 = norm(Fk);
    resid2 = norm(Fkx*u0,Inf);
    resid3 = abs(dot(u0,u0)-1);
    residual = resid1+resid2+resid3;
end

assert(tries<maxTries,"Newton's method failed to converge")

Fkmu = fcns.fMu(xBif,muBif);
Fbig=full([Fkx Fkmu]);
deficiency=length(Fkmu)-rank(Fbig,2*sqrt(tol));

% bifType = -1 for folds
% bifType = 1 for branch points

if deficiency==0
    bifType=-1; if options.verboseFlag; fprintf('Fold point detected ');end
else
    bifType=1; if options.verboseFlag; fprintf('Branch point detected '); end
end
