function flag= hasPotential(G)
if isempty(G.potential)
    flag=false;
else
    flag=true;
end