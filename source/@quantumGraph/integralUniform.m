function z = integralUniform(G,yColumn)

% This does not check if yColumn is compatible with the template G.
% It just plows ahead and returns an error if it doesn't work

if exist('yColumn','var')
    G.column2graph(yColumn);
end

dx = G.Edges.integrationWeight;


weightVec=G.Edges.Weight;
z=0;
for k = 1:numedges(G)
    z = z + edgeIntegral(k);
end


% Note that because x-values on the edges of the graph are offset by dx/2
% each interior point lies at the midpoint of a domain of size dx and using the midpoint
% rule to compute dot products is second order accurate (i.e., we don't need
% to modify the rule near the endpoints, as for the trapezoidal rule)
function z = edgeIntegral(k)
v1 = G.Edges.y{k};
if ~isinf(G.L(k))
    z = weightVec(k)* dx{k} * sum(v1(2:end-1));
else
    integrand =  dx{k} .* v1;
    z= weightVec(k)* sum(integrand(2:end-1));
end

end

end