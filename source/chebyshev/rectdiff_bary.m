function P = rectdiff_bary(m, n)
% Compute projection matrix for downsampling.

% Parse input:
if nargin == 1
    n = m;
    m = n - 1;
end

nm1 = n - 1;                    % For convenience.
T = (nm1:-1:0)*pi/nm1;          % Second-kind grid (angles).
TAU = ((m-1:-1:0).'+.5)*pi/m;   % First-kind grid (angles).

% Barycentric weights:
w = ones(1,n); 
w(2:2:end) = -1; 
w([1,n]) = 0.5*w([1,n]);

% BARYMAT:
P = 2*bsxfun( @(u,v) sin((v+u)/2) .* sin((v-u)/2), T, TAU ); % Trig trick
P = bsxfun(@rdivide, w, P);         % w(k)/(y(j)-x(k)).
P = bsxfun(@rdivide, P, sum(P, 2)); % Normalization.

% Flipping trick:
ii = logical(rot90(tril(ones(m, n)), 2)); 
ii = fliplr(ii);
rot90D = rot90(P, 2);
P(ii) = rot90D(ii);
P(isnan(P)) = 1;