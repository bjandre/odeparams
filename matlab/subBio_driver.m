%
% $Id: subBio_driver.m 5 2008-11-18 04:11:57Z bjandre $
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

% fill the ode parameter estimator input data structure
OPEinput.numEqns = 2;
OPEinput.odeFunc = @monodSX;
OPEinput.dataFile = 'examples/substrate-biomass/guad-x-s.csv';
OPEinput.initialParams = [0.16; 200.0; 5.0];
OPEinput.verifyODE = true;

[params, time, plotData] = odeParamEst(OPEinput);

save('examples/substrate-biomass/sub-bio.params.txt', 'params', '-ascii');
save('examples/substrate-biomass/sub-bio.time.txt', 'time', '-ascii');
save('examples/substrate-biomass/sub-bio.plotData.txt', 'plotData', '-ascii');

%%
% plot
figType='pdf'; % don't forget to change this in the print command in comparisonplot.m
figBaseName = 'subBio';
filename = strcat(figBaseName, '.', figType);
figureTitle = 'Fit of T. Thioparus growth on sodium thiosulfate. Monod';
xTitle ='time (hours)';
yTitle = 'S or X (mg/L)';
labelNames = {'X data'; 'X fit'; 'S data'; 'S fit'};
rateLaw = strcat('mu_{max}:', num2str(real(params(1))), '  K_s: ', num2str(real(params(2))), '  Y: ', num2str(real(params(3))));
comparisonplot(time, plotData, figureTitle, xTitle, yTitle, labelNames, rateLaw, filename)


%% try a different model
clear;
% fill the ode parameter estimator input data structure
OPEinput.numEqns = 2;
OPEinput.odeFunc = @monodSXdeath;
OPEinput.dataFile = 'examples/substrate-biomass/guad-x-s.csv';
OPEinput.initialParams = [0.01; 100.0; 0.01; 0.25];
OPEinput.lowerBounds = [1.0e-10; 1.0; 1.0e-10; 1.0e-10];
OPEinput.upperBounds = [10.0; 1.0e3; 1.0e3; 1.0e3];
OPEinput.verifyODE = true;

[params, time, plotData] = odeParamEst(OPEinput);

%%
% plot
figType='pdf'; % don't forget to change this in the print command in comparisonplot.m
figBaseName = 'subBioDeath';
filename = strcat(figBaseName, '.', figType);
figureTitle = 'Fit of T. Thioparus growth on sodium thiosulfate. Monod with death';
xTitle ='time (hours)';
yTitle = 'S or X (mg/L)';
labelNames = {'X data'; 'X fit'; 'S data'; 'S fit'};
note = strcat('mu_{max}:', num2str(real(params(1))), '  K_s: ', num2str(real(params(2))), '  Y: ', num2str(real(params(3))), '  b: ', num2str(real(params(4))));
comparisonplot(time, plotData, figureTitle, xTitle, yTitle, labelNames, note, filename)
