function Dp = diffMatrixOrderP(m,n,P,L)
% Compute the mxn rectangular differentiation matrix of order P>1 which
% maps from n-point Chebyshev grid of the second kind to m-point Chebyshev
% grid of the first kind and L is the length of the interval. 


t = cos(pi*(0:n-1)/(n-1));                  % Cheb nodes second kind
tau = cos( ((2*(0:(m-1))+1)*pi)/(2*m) );    % Cheb nodes first kind
Tn = @(x,n,p) chebyPolyDeriv(x,n,p);        % Chebyshev polynomial
Dp = zeros(m,n);                            % Initialize the pth derivative matrix

D1 = chebyshevDeriv(n,2);
Project = rectdiff_bary(m,n);
Dprev = Project*D1;


if P<0
    disp("Please enter a positive value")
    return
elseif P==0
    Dp = Project*eye(n);
    return
elseif P==1
    Dp = -Dprev*2/L;
    return
elseif P>2
    disp("This code is not functional for derivatives higher than order 2 yet")
    return
end

% Trig trick for tau_i - t_j
TauT = zeros(m,n);
for i=1:m
    for j=1:n
        phij = (j-1)*pi/(n-1);
        thetai = (2*i-1)*pi/(2*m);
        TauT(i,j) = -2 * sin( (thetai+phij)/2 ) * sin( (thetai-phij)/2 );
    end
end

% Construction of Dp
for i=1:m
    
    for j=1:n+1-i 
        firstTerm = (-1)^(j-1)/(2*(n-1)) * (Tn(tau(i),n,P) - Tn(tau(i),n-2,P));
        if j==1 || j==n
            firstTerm = firstTerm / 2;
        end
        
        Dp(i,j) = ( firstTerm - P*Dprev(i,j) ) / ( TauT(i,j) );    % The Pth Derivative with trig trick
        
        Dp(m+1-i,n+1-j) = Dp(i,j);         % Flipping trick
        
    end
    
end

% Sum Row to Zero Trick
for i=1:m
    TauTRowi = abs(TauT(i,:));
    thisj = find( TauTRowi == min(TauTRowi) );    % Min tau_i - t_j value for fixed i
    DpRowSum = sum(Dp(i,:));
    adjustme = Dp(i,thisj);
    Dp(i,thisj) = -DpRowSum + adjustme;
end

Dp = (-1)^P*Dp.*4/L^2;     % Scale by length of interval

end