%
% $Id: iob_driver.m 5 2008-11-18 04:11:57Z bjandre $
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
clear;

% user data
% none

odeOptions = odeset('Stats','on');

% fill the ode parameter estimator input data structure
OPEinput.numEqns = 1;
OPEinput.odeFunc = @monodGrowth;
OPEinput.dataFile = 'examples/iob-kinetics/2007-08-21-k108-Lf.csv';
OPEinput.initialParams = [0.16; 200.0; 5.0];
OPEinput.lowerBounds = [1.0e-5; 1.0; 1.0];
OPEinput.upperBounds = [10.0; 1.0e3; 1.0e3];
OPEinput.userParams = [1.0];
OPEinput.odeOptions = odeOptions;
OPEinput.verifyODE = true;

[params, time, plotData] = odeParamEst(OPEinput);

save('examples/iob-kinetics/k108.params.txt', 'params', '-ascii');
save('examples/iob-kinetics/k108.time.txt' ,'time', '-ascii');
save('examples/iob-kinetics/k108.plotData.txt', 'plotData', '-ascii');

%%
% plot
figType='pdf'; % don't forget to change this in the print command in comparisonplot.m
figBaseName = 'iob';
filename = strcat(figBaseName, '.', figType);
figureTitle = 'Fit of Lferrooxidans Fe^{+2} oxidation to Monod with growth rate';
xTitle ='time (hours)';
yTitle = 'Fe^{+2} (mg/L)';
labelNames = {'data'; 'fit'};
rateLaw = strcat('dS/dt= -', num2str(real(params(1))), 'S(S_0 + ', num2str(real(params(3))), ' - S)/(', num2str(real(params(2))), ' + S)');
comparisonplot(time, plotData, figureTitle, xTitle, yTitle, labelNames, rateLaw, filename)
