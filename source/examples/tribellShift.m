function V2=tribellShift(V1,N1,N2)
% Function used in resolving double and triple eigenfunctions of tribell 
d1=3*N1;
d2=d1+1;
d3=length(V1);
handlePart=V1(1:d1);
loopPart=V1(d2:d3);
V2a=circshift(handlePart,N1);
V2b=circshift(loopPart,N2);
V2=[V2a;V2b];