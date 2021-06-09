function c=mcolor(varargin)
% Choose the kth color out of the 7 colors in the matlab default line color
% order 
% The default line order in matlab since 2014b are variants of
% 1 -- blueish (as opposed to blue which is [0 0 1])
% 2 -- reddish
% 3 -- yellowish
% 4 -- purpleish
% 5 -- greenish
% 6 -- cyanish
% 7 -- maroonish
% You can use the number from the color order or the name (with or without
% the 'ish') or else the first letter of the name

assert(nargin==1,'only one input argument')
if isnumeric(varargin{1})
    ind=varargin{1};
    assert(round(ind)==ind&&ind>0&&ind<8,'k must be an integer between 1 and 7 \n')
elseif ischar(varargin{1})||isstring(varargin{1})
    str=varargin{1};
    name=[
        "blueish"
        "reddish"
        "yellowish"
        "purpleish"
        "greenish"
        "cyanish"
        "maroonish"
        ];
    ind = find(startsWith(name, str, 'IgnoreCase', true), 1);
    assert(~isempty(ind),'string does not match any of the default line colors')
else
    error('input must be either an integer from 1 to 7, a character, or a string')
end


c=[        0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

c=c(ind,:);