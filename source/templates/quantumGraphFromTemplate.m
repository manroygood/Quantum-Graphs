function Phi = quantumGraphFromTemplate(tag,varargin)

constructor=str2func(tag);
Phi=constructor(varargin{:});

plotCoordFunc= tag+"PlotCoords";
if exist(plotCoordFunc,'file')
    plotCoordFunc = str2func(plotCoordFunc);
    Phi.addPlotCoords(plotCoordFunc);
else
    msg= "No such file: "+ plotCoordFunc;
    errordlg(msg)
end