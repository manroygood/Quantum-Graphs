function resetPlotPreferences
% Run at shutdown of the quantum graph project.
% Undoes the effects of setPlotPreferences.m

if exist('tmp','dir')
    
    default=load('tmp/default.mat');
    default=default.default;
    
    % Change some settings back to the default values
    set(groot,'DefaultAxesFontSize',default.AxesFontsize)
    set(groot,'DefaultLineLineWidth',default.LineLineWidth)
    set(groot,'DefaultFunctionLineLineWidth',default.FunctionLineLineWidth)
    set(groot,'DefaultTextInterpreter',default.TextLabelInterpreter)
    set(groot,'DefaultAxesTickLabelInterpreter',default.AxesTickLabelInterpreter)
    set(groot,'DefaultLegendInterpreter',default.LegendInterpreter);
    set(groot,'DefaultColorbarTickLabelInterpreter',default.ColorbarTickLabelInterpreter)
    
    % Remove the temporary directory including the files it contains
    rmdir('tmp','s')
end