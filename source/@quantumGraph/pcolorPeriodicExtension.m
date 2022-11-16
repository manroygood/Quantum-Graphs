function pcolorPeriodicExtension(PhiX,Phi,extensionMap,v)
if nargin==4
    Phi.column2graph(v);
end
PhiX.extendPeriodic(Phi,extensionMap);v=graph2column(PhiX);
PhiX.pcolor(v)