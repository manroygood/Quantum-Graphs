
function label = getLabel(j)
% GETLABEL - writes a 3-numeral string from a number between 0 and 999

if(or(j<0,j>1000))
  error('j out of range');
end

label='000';
if 0<j && j<10
  label(3)=num2str(j);
elseif 9<j && j<100
  label(2:3)=num2str(j);
elseif 99<j
  label=num2str(j);
end
