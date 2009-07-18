function volumeplot(X1, Y1)
%
% $Id: volumeplot.m 5 2008-11-18 04:11:57Z bjandre $
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
  
%CREATEFIGURE(X1,Y1)
%  X1:  stairs x
%  Y1:  stairs y

%  Auto-generated by MATLAB on 28-Jun-2007 16:48:01

% Create figure
figure1 = figure;

% Create axes
axes('Parent',figure1);
box('on');
hold('all');

% Create xlabel
xlabel({'time(seconds)'});

% Create ylabel
ylabel({'volume(L)'});

% Create title
title({'Kinetics Experiment 1 Volume Plot'});

% Create stairs
stairs(X1,Y1,'Color',[0 0 1],'DisplayName','Volume Data');

