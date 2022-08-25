function [leadingCoeff,leadingExponent]=leadingMonomial(f)
syms(symvar(f,1)); %this defines z as the symbolic variable
stopNow=false;
order = 6;
maxOrder = 10;
while ~stopNow && order <= maxOrder
    a=sym2poly(series(f,z,0,'Order',order)); 
    if any(a)
        stopNow=true;
        b=fliplr(a);
        leadingExponent=find(b,1,'first')-1;
        leadingCoeff=b(leadingExponent+1);
    end
    order = order+2;
end
