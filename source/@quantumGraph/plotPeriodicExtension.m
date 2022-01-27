function plotPeriodicExtension(PhiX,Phi,extensionMap,v)
if nargin==4
    Phi.column2graph(v);
end
PhiX.extendPeriodic(Phi,extensionMap);
PhiX.plot