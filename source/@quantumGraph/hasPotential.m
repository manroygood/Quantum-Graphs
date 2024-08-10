function flag= hasPotential(G)
if isempty(G.potentialMatrix)
    flag=false;
else
    flag=true;
end