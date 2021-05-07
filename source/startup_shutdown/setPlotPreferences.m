function setPlotPreferences
% These codes were written using my plotting preference
%
% The first two (fontsize and linewidth) are mereley the author's preferences
% (However, they were chosen so that lines will be drawn thickly enough to
% be seen in presentations, and so that font sizes are large enough that
% journals won't ocmplain about the figures.)
%
% The remaining preferences are to use 'latex' as the text interpreter
% wherever possible. This is to match the style of most journal articles
% main text and also to allow more sophisticated mathematics in the figure
% annotation.
%
% The codes were written, for my own use, with latex as the text
% interpreter, and MATLAB will throw warnings unless these plot settings
% are adjusted.
%
% This program is called when the Project file is opened. It saves the
% user's defaults to a temporary file. When the user exits the project,
% the preferences are set back to their original values and the temporary
% file is removed.

% Save the user's default settings
default.AxesFontsize=get(groot,'DefaultAxesFontSize');
default.LineLineWidth=get(groot,'DefaultLineLineWidth');
default.FunctionLineLineWidth=get(groot,'DefaultFunctionLineLineWidth');
default.TextLabelInterpreter=get(groot,'DefaultTextInterpreter');
default.AxesTickLabelInterpreter=get(groot,'DefaultAxesTickLabelInterpreter');
default.LegendInterpreter=get(groot,'DefaultLegendInterpreter');
default.ColorbarTickLabelInterpreter=get(groot,'DefaultColorbarTickLabelInterpreter');

% Create a temporary directory to store the users default settings
if ~exist('tmp','dir')
    mkdir('tmp')
end
save(fullfile('tmp','default.mat'),'default')

% Reset to use Roy's preferred settings (which he believes are superior)
set(groot,'DefaultAxesFontSize',14)
set(groot,'DefaultLineLineWidth',2)
set(groot,'DefaultFunctionLineLineWidth',2)
set(groot,'DefaultTextInterpreter','latex')
set(groot,'DefaultAxesTickLabelInterpreter','latex')
set(groot,'DefaultLegendInterpreter','latex');
set(groot,'DefaultColorbarTickLabelInterpreter','latex')