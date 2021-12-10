function newString=toGreek(oldString)
different={'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta',...
    'theta', 'iota', 'kappa', 'lambda', 'mu', 'nu', 'xi', 'pi', 'rho',...
    'sigma', 'tau', 'upsilon', 'phi', 'xi', 'psi', 'omega', 'Gamma', 'Delta', ...
    'Theta', 'Lambda', 'Xi', 'Pi', 'Sigma', 'Upsilon', 'Phi', 'Psi', 'Omega'};
sameGreek={'omicron','Alpha','Beta','Epsilon','Zeta','Eta','Iota','Kappa','Mu','Nu','Omicron',...
    'Rho','Tau','Chi'};
sameEnglish={'o','A','B','E','Z','H','I','K','M','N','O','P','T','X'};
indecesDifferent=strcmp(oldString,different);
indecesSame = strcmp(oldString,sameGreek);
if any(indecesDifferent)
    newString=['\' oldString];
elseif any(indecesSame)
    newString=sameEnglish{indecesSame};
else
    newString=oldString;
end