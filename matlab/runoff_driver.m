%
% $Id: runoff_driver.m 5 2008-11-18 04:11:57Z bjandre $
%
% Copyright 2007, 2008 Benjamin Andre
%
% This file is part of odeparams.
%
% odeparams is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%  
% Odeparams is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%  
% You should have received a copy of the GNU General Public License
% along with odeparams.  If not, see <http://www.gnu.org/licenses/>.
%

%
% driver script to call odeParamEst and then plot the results
%

%%
%
% input data
%

% user data
clear;

odeOptions = odeset('Stats','on');

% fill the ode parameter estimator input data structure
OPEinput.numEqns = 4;
OPEinput.odeFunc = @rrof;
OPEinput.dataFile = 'examples/runoff/runoffdata.csv';
OPEinput.initialParams = [0.4;0.04;0.5;20.0;20.0;0.4];
OPEinput.userParams = [];
OPEinput.odeOptions = odeOptions;
OPEinput.verifyODE = true;

[params, time, plotData] = odeParamEst(OPEinput);

save('examples/runoff/runoff.params.txt', 'params', '-ascii');
save('examples/runoff/runoff.time.txt', 'time', '-ascii');
save('examples/runoff/runoff.plotData.txt', 'plotData', '-ascii');
%%
% plot
figType='pdf'; % don't forget to change this in the print command in comparisonplot.m
figBaseName = 'runoff';
filename = strcat(figBaseName, '.', figType);
figureTitle = 'hydrograph';
xTitle ='time (days)';
yTitle = 'Qcum';
%labelNames = {'Fe^{+2} data'; 'Fe^{+2} fit'; 'Fe^{+3} data'; 'Fe^{+3} fit'};
%rateLaw = strcat('r= ', num2str(real(params(3))), '[Fe^{+3}]^{', num2str(real(params(2))), '} [Fe^{+2}]^{', num2str(real(params(3))),'}')
%comparisonplot(time, plotData, figureTitle, xTitle, yTitle, labelNames, rateLaw, filename)
plot(time,plotData(:,7),time,plotData(:,8))
