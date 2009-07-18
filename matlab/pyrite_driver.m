%
% $Id: pyrite_driver.m 5 2008-11-18 04:11:57Z bjandre $
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
surfaceArea = 0.05; % m^2 g^-1
pyriteWeight = 2.0; % grams
surfaceArea = surfaceArea * pyriteWeight;

MaxStepsize=50;
odeOptions = odeset('Stats','on');
odeOptions = odeset(odeOptions,'MaxStep',MaxStepsize);

% fill the ode parameter estimator input data structure
OPEinput.numEqns = 2;
OPEinput.odeFunc = @pyriteWilliamson;
OPEinput.dataFile = 'examples/pyrite-fe3-kinetics/PyriteFe3.cvs';
OPEinput.initialParams = [-0.4; 0.93; 10^-6.07];
OPEinput.userParams = [surfaceArea];
OPEinput.odeOptions = odeOptions;
OPEinput.verifyODE = true;

[params, time, plotData] = odeParamEst(OPEinput);

save('examples/pyrite-fe3-kinetics/pyrite-fe3.params.txt', 'params', '-ascii');
save('examples/pyrite-fe3-kinetics/pyrite-fe3.time.txt', 'time', '-ascii');
save('examples/pyrite-fe3-kinetics/pyrite-fe3.plotData.txt', 'plotData', '-ascii');

%%
% plot
figType='pdf'; % don't forget to change this in the print command in comparisonplot.m
figBaseName = 'pyrite';
filename = strcat(figBaseName, '.', figType);
figureTitle = 'Fit of pyrite dissolution date with Fe^{+2} inhibition rate';
xTitle ='time (seconds)';
yTitle = 'Mass (mol)';
labelNames = {'Fe^{+2} data'; 'Fe^{+2} fit'; 'Fe^{+3} data'; 'Fe^{+3} fit'};
rateLaw = strcat('r= ', num2str(real(params(3))), '[Fe^{+3}]^{', num2str(real(params(2))), '} [Fe^{+2}]^{', num2str(real(params(3))),'}')
comparisonplot(time, plotData, figureTitle, xTitle, yTitle, labelNames, rateLaw, filename)
