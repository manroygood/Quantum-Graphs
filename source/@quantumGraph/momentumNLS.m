function momentum = momentumNLS(Phi,yColumn)

if exist('yColumn','var')
    Phi.column2graph(yColumn);
else
    yColumn=Phi.graph2column;
end

yDerivative=Phi.derivative;

integrand = imag(yDerivative.*conj(yColumn));
nx = Phi.nx(1);
integrand(1:nx)= -integrand(1:nx);
momentum=Phi.integral(integrand);