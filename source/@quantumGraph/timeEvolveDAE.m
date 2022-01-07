function [u,t] = timeEvolveDAE(G,f,u0,h,tend,scheme)
% Given a graph G, function f and initial condition u0, this function 
% evolves the solution to f(t,x) = u_xx in time using a 2nd, 4th or 8th
% order scheme until t=tend using the given step size h. The result will be
% a matrix the ith row of u is the solution evaluated at ith value of tvec.

told = 0;        % t_n
tnew = told;     % t_n+1
s = 4;           % Number of b_i coeff's
j = 1;           % Index for t and u
m = round(tend/h);      % Number of t points
n = length(u0);         % Number of x points

nEdges = length(G.L);   % Number of edges
nBCs = 2*nEdges;        % Number of BC conditions
A = full(G.laplacianMatrix);                % The second spatial derivative operator
B = full(G.weightMatrix);                   % The rectangular collocation or weight matrix
C = [B(1:(n-nBCs),:); A((n-nBCs+1):n,:)];   % Weight matrix diagonal with boundary data in bottom rows

% Filter highest mode out of C
[U,S,V] = svd(full(C));
d = 1./diag(S);
Sinv = transpose(diag(d));
Sinv(Sinv<.01) = 0;
Cinv = V*Sinv*transpose(U);

if size(u0,1)==1    % Corrects orientation of u0
    u0=u0';
end

u = zeros(n,m);
t = zeros(1,m);
u(:,1) = u0;
uold = u(:,1);      % u_n

a = [0 0 0 0; 1/2 0 0 0; 0 1/2 0 0; 0 0 1 0];
c = zeros(s,1);

for i=1:s
    c(i) = sum(a(i,:));
end


while tnew < tend
    told = tnew;
    
    if scheme == 2                  % Ralston method
        
        b = [1/4 3/4];
        
        k1 = f(told , uold);
        k2 = f(told + (2/3)*h, uold + (2/3)*h*(C\k1));
        k = [transpose(k1); transpose(k2)];
        kappa = [transpose(C\k1); transpose(C\k2)];
        
    elseif scheme == 4              % 3/8th rule
        
        b = [1/8 3/8 3/8 1/8];
        
        k1 = f(told , uold);
        k2 = f(told + (1/3)*h, uold + (1/3)*h*(C\k1));
        k3 = f(told + (2/3)*h, uold - (1/3)*h*(C\k1) + h*(C\k2));
        k4 = f(told + h      , uold +       h*(C\k1) - h*(C\k2) + h*(C\k3));

        k = [transpose(k1); transpose(k2); transpose(k3); transpose(k4)];
        kappa = [transpose(C\k1); transpose(C\k2); transpose(C\k3); transpose(C\k4)];
        
    elseif scheme == 8              % Dopri8
        
        b = [(5.42937341165687622380535766363e-2) 0 0 0 0 (4.45031289275240888144113950566) (1.89151789931450038304281599044) -(5.8012039600105847814672114227) (3.1116436695781989440891606237e-1) -(1.52160949662516078556178806805e-1) (2.01365400804030348374776537501e-1) (4.47106157277725905176885569043e-2)];
        
        k1 = f(told , uold);
        k2 = f(told + (0.526001519587677318785587544488e-01)*h , uold + (5.26001519587677318785587544488e-2)*h*(C\k1));
        k3 = f(told + (0.789002279381515978178381316732e-01)*h , uold + (1.97250569845378994544595329183e-2)*h*(C\k1) + (5.91751709536136983633785987549e-2)*h*(C\k2));
        k4 = f(told + (0.118350341907227396726757197510e+00)*h , uold + (2.95875854768068491816892993775e-2)*h*(C\k1) + (0.0)*h*(C\k2) + (8.87627564304205475450678981324e-2)*h*(C\k3));
        k5 = f(told + (0.281649658092772603273242802490e+00)*h , uold + (2.41365134159266685502369798665e-1)*h*(C\k1) + (0.0)*h*(C\k2) + (-8.84549479328286085344864962717e-1)*h*(C\k3) + (9.24834003261792003115737966543e-1)*h*(C\k4));
        k6 = f(told + (0.333333333333333333333333333333e+00)*h , uold + (3.7037037037037037037037037037e-2) *h*(C\k1) + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (1.70828608729473871279604482173e-1)*h*(C\k4) + (1.25467687566822425016691814123e-1) *h*(C\k5));
        k7 = f(told + (0.25e+00)*h                             , uold + (3.7109375e-2)*h*(C\k1)                       + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (1.70252211019544039314978060272e-1)*h*(C\k4) + (6.02165389804559606850219397283e-2) *h*(C\k5) + (-1.7578125e-2)*h*(C\k6));
        k8 = f(told + (0.307692307692307692307692307692e+00)*h , uold + (3.70920001185047927108779319836e-2)*h*(C\k1) + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (1.70383925712239993810214054705e-1)*h*(C\k4) + (1.07262030446373284651809199168e-1) *h*(C\k5) + (-1.53194377486244017527936158236e-2)*h*(C\k6) + (8.27378916381402288758473766002e-3)*h*(C\k7));
        k9 = f(told + (0.651282051282051282051282051282e+00)*h , uold + (6.24110958716075717114429577812e-1)*h*(C\k1) + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (-3.36089262944694129406857109825)*h*(C\k4)   + (-8.68219346841726006818189891453e-1)*h*(C\k5) + (2.75920996994467083049415600797e1)  *h*(C\k6) + (2.01540675504778934086186788979e1) *h*(C\k7) + (-4.34898841810699588477366255144e1)*h*(C\k8));
        k10 = f(told + (0.6e+00)*h                             , uold + (4.77662536438264365890433908527e-1)*h*(C\k1) + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (-2.48811461997166764192642586468)*h*(C\k4)   + (-5.90290826836842996371446475743e-1)*h*(C\k5) + (2.12300514481811942347288949897e1)  *h*(C\k6) + (1.52792336328824235832596922938e1) *h*(C\k7) + (-3.32882109689848629194453265587e1)*h*(C\k8) + (-2.03312017085086261358222928593e-2) *h*(C\k9));
        k11 = f(told + (0.857142857142857142857142857142e+00)*h, uold + (-9.3714243008598732571704021658e-1)*h*(C\k1) + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (5.18637242884406370830023853209)*h*(C\k4)    + (1.09143734899672957818500254654)    *h*(C\k5) + (-8.14978701074692612513997267357)   *h*(C\k6) + (-1.85200656599969598641566180701e1)*h*(C\k7) + (2.27394870993505042818970056734e1) *h*(C\k8) + (2.49360555267965238987089396762)     *h*(C\k9) + (-3.0467644718982195003823669022)  *h*(C\k10));
        k12 = f(told + (0.1e+00)*h                             , uold + (2.27331014751653820792359768449)   *h*(C\k1) + (0.0)*h*(C\k2) + (0.0)*h*(C\k3) + (-1.05344954667372501984066689879e1)*h*(C\k4) + (-2.00087205822486249909675718444)   *h*(C\k5) + (-1.79589318631187989172765950534e1) *h*(C\k6) + (2.79488845294199600508499808837e1) *h*(C\k7) + (-2.85899827713502369474065508674)  *h*(C\k8) + (-8.87285693353062954433549289258)    *h*(C\k9) + (1.23605671757943030647266201528e1)*h*(C\k10) + (6.43392746015763530355970484046e-1)*h*(C\k11));
        k = [transpose(k1); transpose(k2); transpose(k3); transpose(k4); transpose(k5); transpose(k6); transpose(k7); transpose(k8); transpose(k9); transpose(k10); transpose(k11); transpose(k12)];
        kappa = [transpose(C\k1); transpose(C\k2); transpose(C\k3); transpose(C\k4); transpose(C\k5); transpose(C\k6); transpose(C\k7); transpose(C\k8); transpose(C\k9); transpose(C\k10); transpose(C\k11); transpose(C\k12)];
    else
        
        assert((scheme~=2)&&(scheme~=4)&&(scheme~=8) , 'You must pick a time scheme of 2nd, 4th or 8th order')
        
    end
    
    K = transpose(b*k);
    K((n-nBCs+1):n) = 0;
%     unew = Cinv* (B*uold + h*K);
    unew = uold + C\(h*K);
    tnew = told + h;
    
    j = j + 1;
    u(:,j) = unew;
    uold = unew;
    t(j) = tnew;
end



end