function l = letter(n,whichcase)

letters='abcdefghijklmnopqrstuvwxyz';
N=mod(n,26);
if N==0; N=26;end
nCopies=ceil(n/26);
l=blanks(nCopies);
for k=1:nCopies
l(k)=letters(N);
end
if exist('whichcase','var')
    if strncmpi(whichcase,'up',2)
        l=upper(l);
    end
end

