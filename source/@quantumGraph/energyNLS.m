function E = energyNLS(Phi,yColumn,fcns)

if exist('yColumn','var')
    Phi.column2graph(yColumn);
else
    yColumn=Phi.graph2column;
end

yDerivative=Phi.derivative;

term1=Phi.integral(yDerivative.*conj(yDerivative));
term2=Phi.integral(fcns.F(yColumn));

vertexTerm = dot(Phi.robinCoeff,(Phi.Nodes.y).^2);

E = vertexTerm + term1 - term2;