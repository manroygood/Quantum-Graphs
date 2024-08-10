function [g,gprime]=getStretchedDerivWeightsCheb(s,L)

sqs = sqrt(1-s);
S = sech(L*(1-sqs));
T = tanh(L*(1-sqs));
g = 2*sqs.*S/L;
gprime = -S.*(T+1/L./sqs);