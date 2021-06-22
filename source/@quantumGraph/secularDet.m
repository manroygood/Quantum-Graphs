function [f,S,D] = secularDet(G)
L = sym(G.L);
n = numedges(G);
S = sym(zeros(2*n));
D = sym(zeros(2*n));
Eye = sym(eye(2*n));
ThetaR = 0;             % Phase angle for Det(S) from Robin
ThetaK = 0;             % Phase angle for Det(S) from Kirchoff
syms x
assume(x >= 0)

for j=1:n       % Builds D
    entry=exp(1i*L(j)*x);
    D(j,j)=entry;
    D(j+n,j+n)=entry;
end


for j=1:2*n
    if j<=n             % Finds degree of vertex
        jbar=j+n;
        dv=fullDegreeEtc(G,G.EndNodes(j,2));            % When e_j goes into the node
    else
        jbar=j-n;
        dv=fullDegreeEtc(G,G.EndNodes(j-n,1));          % When e_jbar leaves the node
    end
    
    for jprime =1:2*n                                   % Builds S
        if dv==1 && jprime==jbar
            if j<=n && ~isnan(G.robinCoeff(G.EndNodes(j,2)))        % Robin Boundary Conditions
                alpha = G.robinCoeff(G.EndNodes(j,2));
                S(jprime,j) = (1i*x+alpha)/(1i*x-alpha);
                if alpha == 0
                    ThetaR = ThetaR+pi;
                else
                    ThetaR = ThetaR + atan(alpha/x);
                end
            elseif jprime<=n && ~isnan(G.robinCoeff(G.EndNodes(jprime,1)))
                alpha = G.robinCoeff(G.EndNodes(jprime,1));
                S(jprime,j) = (1i*x+alpha)/(1i*x-alpha);
                if alpha == 0
                    ThetaR = ThetaR+pi;
                else
                    ThetaR = ThetaR + atan(alpha/x);
                end
            elseif j<=n && isnan(G.robinCoeff(G.EndNodes(j,2)))                           % Dirichlet BCs
                S(jprime,j) = -1;
            elseif jprime<=n && isnan(G.robinCoeff(G.EndNodes(jprime,1)))                 % Dirichlet BCs
                S(jprime,j) = -1;
            end
        elseif jprime==jbar
            node = G.sharedNode(j,jprime);              % Kirchhoff condition
            alpha = G.robinCoeff(node);
            S(jprime,j) = 2/(dv-alpha/(1i*x))-1;
            ThetaK = ThetaK + atan(alpha/(dv*x))/dv;    % Divide by dv because the code loops through edges so we'll do this for each edge
        elseif G.follows(j,jprime)
            node = G.sharedNode(j,jprime);              % Kirchhoff condition
            alpha = G.robinCoeff(node);
            S(jprime,j) = 2/(dv-alpha/(1i*x));
        end
    end
end
LL=sum(L);

f = det(Eye-S*D)*exp(-1i*x*LL)*exp(1i*ThetaR)*exp(1i*ThetaK);
f = rewrite(f,'sin');
f = simplify(f);
[n,d] = numden(f);
fvec1 = coeffs(n);
fvec2 = coeffs(d);
const1 = fvec1(1)/fvec2(1);
f = prod(factor(f))/(const1);
f = simplify(expand(f));

if imag(f) == 0
    f = real(f);
elseif real(f) == 0
    f = imag(f);
else
    disp('Warning: Secular Determinant is not real.')
end

end