function [params, time, plotData] = odeParamEst(OPEinput)
global OPEuser
%%
% function odeParamEst(OPEinput)
%
% Purpose: matlab script for using experimental data to fit parameters to
% arbitrary ode's using nonlinear regression
%
% $Id: odeParamEst.m 5 2008-11-18 04:11:57Z bjandre $
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

% Usage Tips:
%  - Have you checked the user defined functions to make sure they are
%  behaiving correctly? Have you plotted the ode function with a known
%  set of parameters? Don't you think you should try that?  Why don't
%  you do it now, I'll wait. I don't care if you think you've done it
%  already, do it again. No seriously, do it.
%  
%  - Are you using a meaningful set on initial conditions?
%  i.e. does your data have a noisy initial data point? This is an
%  IVP, if you don't have a good starting point, it won't work.
%
%  - Are you using a meaningful set of initial parameter values? 
%
%  - did you check your units? Are you sure?
%
%  - This code is solving an uncostrained minimization
%  problem. That means it can choose any value for the
%  parameters. Does your ode function have special needs, i.e. no
%  negative values? If so, try modifing your function: if a < 0 then
%  xdot = 0 or modify the solver to use a constrained solver.
%


%%
%
% required parameters. If the user does not specify these, it is an error.
%
if isfield(OPEinput, 'dataFile') == false
    error('You must specify a cvs file with the data you want to fit in OPEinput.data.');
end

if isfield(OPEinput, 'numEqns') == false
    error('You must specify the number of dependent variables being used in OPEinput.numEqns.');
end

%
% read data and save into data structures
%
rawdata = csvread(OPEinput.dataFile);
[nrows, ncols]=size(rawdata);

% independent variable
OPEuser.time = rawdata(:,1);

% dependent variables
OPEuser.expData = zeros(nrows,OPEinput.numEqns);
for d = 1:OPEinput.numEqns
    OPEuser.expData(:,d) = rawdata(:,2*d);
end

% weights
OPEuser.weight = zeros(nrows,OPEinput.numEqns);
for d = 1:OPEinput.numEqns
    OPEuser.weight(:,d) = rawdata(:,1+2*d);
end

% any extra columns are user data
userCols = ncols - (1+2*OPEinput.numEqns);
if userCols > 0
    lastDataCol = 1+2*OPEinput.numEqns;
    OPEuser.userData = zeros(nrows, userCols);
    for d = 1:userCols
        OPEuser.userData(:,d) = rawdata(:,lastDataCol+d);
    end
end

% user defined ode function
if isfield(OPEinput, 'odeFunc')
    OPEuser.odeFunc = OPEinput.odeFunc;
else
    error('You must specify the ode function in OPEinput.odeFunc.');
end

% initial guess for parameters
if isfield(OPEinput, 'initialParams') == false
    error('You must specify an initial guess for the parameters in OPEinput.initialParams.');
end

%%
% default parameters, if the user does not specify these, we can use a
% default.
%

% which minimization function to use for lsqnonlin
if isfield(OPEinput, 'minFunc')
    minFunc = OPEinput.minFunc;
else
    % default is the weighted least squares 
    minFunc = @odeParamEstLSQ;
end

% initial conditions
if isfield(OPEinput, 'initialConditions')
    OPEuser.ic = OPEinput.initialConditions;
else
    % just use the first row of the data
    OPEuser.ic = OPEuser.expData(1,:);
end

% options to pass to ode integrator
if isfield(OPEinput, 'odeOptions')
    OPEuser.odeOptions = OPEinput.odeOptions;
else
    OPEuser.odeOptions = odeset('Stats','on');
end


%%
% optional parameters
%
bounds = false;
if isfield(OPEinput, 'lowerBounds') || isfield(OPEinput, 'upperBounds')
    % if either the upper or lower bounds are specified, then both must be
    % specified. They must both be the same size as params
    if size(OPEinput.initialParams) ~= size(OPEinput.lowerBounds)
        error('odeParamEst: the size of initialParams must be the same as lowerBounds.');
    end
    if size(OPEinput.initialParams) ~= size(OPEinput.upperBounds)
        error('odeParamEst: the size of initialParams must be the same as upperBounds.');
    end
    bounds = true;
    % options to pass to lsqnonlin. can only pass options if passing bounds.  
    if isfield(OPEinput, 'minOptions')
        minOptions = OPEinput.minOptions;
    else    
        minOptions = optimset('Display', 'final');
    end
end

% did the user want any speciald parameters passed to their functions?
if isfield(OPEinput, 'userParams')
    OPEuser.userParams = OPEinput.userParams;
end

% verify that the ode function is working properly
if isfield(OPEinput, 'verifyODE')
    if OPEinput.verifyODE == true
        figure;
        OPEuser.params = OPEinput.initialParams;
        ode45(OPEuser.odeFunc, OPEuser.time, OPEuser.ic, OPEuser.odeOptions);
    end
end

%%
% fit the ode using the user function and data
%
if (bounds == true)
    OPEuser.params = lsqnonlin(minFunc, OPEinput.initialParams, OPEinput.lowerBounds, OPEinput.upperBounds, minOptions);
else
    OPEuser.params = lsqnonlin(minFunc, OPEinput.initialParams);
end
display('Final parameter estimates:');
display(OPEuser.params);

%%
% generate plot data
clear plotdata
plotData = zeros(nrows, 2*OPEinput.numEqns);
IC = OPEuser.expData(1,:);
[T,Y] = ode45(OPEuser.odeFunc, OPEuser.time, IC, OPEuser.odeOptions);
for d = 1:OPEinput.numEqns
    plotData(:,2*d-1) = OPEuser.expData(:,d);
    plotData(:,2*d) = Y(:,d);
end

params = OPEuser.params;
time = OPEuser.time;
return 
