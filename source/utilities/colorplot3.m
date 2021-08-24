function h = colorplot3(x1,x2,x3,y)
h = surface([x1 x1]',[x2 x2]',[x3 x3]',[y y]',...
    'facecolor','none','edgecolor','flat','linewidth',6);
colormap(parula(12))
end
% This function is based on
% https://www.mathworks.com/matlabcentral/answers/5042-how-do-i-vary-color-along-a-2d-line