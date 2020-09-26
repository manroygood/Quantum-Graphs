function n=label2str(label)
assert(ischar(label),'input must be character or string')
len=length(label);
k=0;
while k<len && (~isempty(str2num(label(len-k))))
    k=k+1;
end
if k>0
    n=str2num(label(end-k+1:end));
else
    n=[];
end

