function HHBDetector(Phi,PhiVec,muVec)
% Detects if there is a Hamilton Hopf Bifrucation point between mu1 and mu2
%
% Parameters
% ----------
% Phi : Graph
% muVec : the two eignevalues mu1 and mu2
% PhiVec : stationary state solutions associated with muVec
%
% Outputs
% -------
% muBif : the eigenvalue at which there is a HHB
% PhiBif : stationary state solutions associated with muBif

    mu1 = muVec(1);
    mu2 = muVec(end);
    PhiCol1 = PhiVec(:,1);
    PhiCol2 = PhiVec(:,end);

    funcs = getGraphFcns(Phi);          % Defining our JL operator
    JL = @(z,lambda) funcs.JL(z,lambda);
    JL1 = full(JL(PhiCol1,mu1));
    JL2 = full(JL(PhiCol2,mu2));

    [~,val1] = eigsJL(Phi,JL1,16);      % Finds eigenvalues for JL
    [~,val2] = eigsJL(Phi,JL2,16);

    N1 = nnz(imag(val1));               % Number of imagainary eigenvalues
    N2 = nnz(imag(val2));

    % Checks if there are fewer imaginary evals
    if N1 > N2
        [PhiBif,muBif] = HHBLocator(funcs, [PhiCol1';PhiCol2'], [mu1;mu2]);
    else
        assert(~isnan(PhiBif),'Failed to find any HHB.')
    end
end
