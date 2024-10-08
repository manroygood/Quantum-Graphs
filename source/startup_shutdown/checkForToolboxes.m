function checkForToolboxes

if ~license('test','symbolic_toolbox')
    bigString=['Symbolic Math Toolbox not installed. This is only used'...
        'to calculate secular determinants. If you want to install it, look '...
        'at the ''Home'' tab of the Desktop and click on the icon '...
        'matching the one on the left. This opens the ''Add-On Explorer.'' '...
        'Then search for ''Symbolic Math Toolbox'' and click to install it.'];
    myTitle=('Toolbox not installed');
    myIcon=imread('addons.png');
    msgbox(bigString,myTitle,'custom',myIcon);
end

if ~ (exist('arrow3','file')==2)
    bigString=['The arrow3 package not installed. This is used'...
        'to plot graph layouts. To install it, look '...
        'at the ''Home'' tab of the Desktop and click on the icon '...
        'matching the one on the left. This opens the ''Add-On Explorer.'' '...
        'Then search for ''arrow3'' and click on the ''Arrow3'' package by Tom Davis toinstall it.'];
    myTitle=('Arrow3 not installed');
    myIcon=imread('addons.png');
    msgbox(bigString,myTitle,'custom',myIcon);
end