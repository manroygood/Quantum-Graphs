function [singles,doubles,triples]=separateEigs(lambda)
% Groups together suspected single, double, and triple eigenvalues. Assumes
% they are sorted
tol=1e-10;  % small parameter used to distinguish multiple eigenvalues
d1=diff(lambda);
d2=diff(d1);
doubles=find(abs(d1)<tol);
triples=find(abs(d2)<tol);
doubles=setdiff(doubles,union(triples,triples+1));
singles=1:length(lambda);
singles=setdiff(singles,doubles);
singles=setdiff(singles,doubles+1);
singles=setdiff(singles,triples);
singles=setdiff(singles,triples+1);
singles=setdiff(singles,triples+2);