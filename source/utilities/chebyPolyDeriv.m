function T=chebyPolyDeriv(x,n,p)
% Calculate the Chebyshev pth derivative of the Chebyshev Polynomial
% Tn = cos(n*arccos(x)).

if p==0
    T = cos(n*acos(x));
elseif p==1
    T = (n*sin(n*acos(x))) / sqrt(1 - x^2);
elseif p==2
    T = -(n^2*cos(n*acos(x)))/(1 - x^2) + (n*x*sin(n*acos(x)))/(1 - x^2)^(3/2);
elseif p==3
    T = - (n^3*sin(n*acos(x)))/(1 - x^2)^(3/2) + (3*n^2*x*sin(n*acos(x)))/(1 - x^2)^2 + (n*sin(n*acos(x)))/(1 - x^2)^(3/2) + (3*n*x^2*acos(x))/(1 - x^2)^(5/2);
elseif p<0
    dips("Please enter 0 or a positive integer for p")
    T = 0;
else
    disp("I have only calculated the first 2 derivatives for the Chebyshev polynomials") 
    T = 0;
end

end