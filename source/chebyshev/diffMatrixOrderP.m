function [Dp,TauT] = diffMatrixOrderP(m,n,P,L)
% Compute the mxn rectangular differentiation matrix of order P>=1 which
% maps from n-point Chebyshev grid of the second kind to m-point Chebyshev
% grid of the first kind and L is the length of the interval. 

assert(P>=0,'P must be positive')
assert(P<=2,'P cannot exceed 2')

D1 = chebyshevDeriv(n,L);
Project = rectdiff_bary(m,n);
Dprev = Project*D1;

if P==0
    Dp = Project;
    return
elseif P==1
    Dp = Dprev;
    return
end

% We only handle the case P=2

% Trig trick for tau_i - t_j
phi = linspace(0,pi,n);
theta = linspace(pi/m/2,pi*(1-1/m/2),m)';
TauT =  -2*sin((theta+phi)/2).*sin((theta-phi)/2);

% Construction of Dp
tau = 2*chebptsFirstKind(m)'-1;
trigTerm=chebyPolyDeriv(tau,n,2) - chebyPolyDeriv(tau,n-2,2);
weightVec = (-1).^(0:(n-1))/(2*(n-1)) ; 
weightVec([1 n]) = weightVec([1 n])/2; 
matrix1 = trigTerm(:)*weightVec;
Dp = ( matrix1 + L*Dprev) ./  TauT;
Dp = (Dp + rot90(Dp,2))/2; % Average the matrix with its 180 degree rotation

% Sum Row to Zero Trick
for i=1:m
    [~,j] = min(abs(TauT(i,:)));
    Dp(i,j) = Dp(i,j)-sum(Dp(i,:));
end

Dp = Dp.*4/L^2;     % Scale by length of interval