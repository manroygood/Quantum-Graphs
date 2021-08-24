function z = qgdotCheb(Phi,u1col,u2col)
% Note this does absolutely no checking to determine if two columns are
% compatible with the template Phi. It just surges ahead and returns an
% error if it doesn't work

%     u1 = copy(Phi); u1.column2graph(u1col);
%     u2 = copy(Phi); u2.column2graph(u2col);
%     weightVec = u1.Edges.Weight;
    weightVec = Phi.Edges.Weight;
    [~,nxC,~] = Phi.nx;

    z = 0;
    for k = 1:numedges(Phi)
        z = z + weightVec(k)*edgeDotCheb(Phi,u1col(nxC(k)+1:nxC(k+1)),u2col(nxC(k)+1:nxC(k+1)),k);
    end

end 


function z = edgeDotCheb(Phi,v1,v2,k)

    l = Phi.Edges.L(k);
    f = v1.*v2;
    z = clencurt(f,l);  % Uses Clenshaw-Curtis quadrature to integrate 

end