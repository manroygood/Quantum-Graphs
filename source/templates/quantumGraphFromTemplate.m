function Phi = quantumGraphFromTemplate(tag,varargin)

constructor=str2func(tag);
Phi=constructor(varargin{:});

plotCoordFunc= tag+"PlotCoords";
if exist(plotCoordFunc,'file')
    plotCoordFunc = str2func(plotCoordFunc);
    if Phi.hasDiscretization
        Phi.addPlotCoords(plotCoordFunc);
    else
        warning('quantumGraph must have discretization to define plot coordinate function')
    end
else
    msg= "No such file: "+ plotCoordFunc;
    errordlg(msg)
end