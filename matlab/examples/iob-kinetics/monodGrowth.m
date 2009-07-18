function xdot=monodGrowth(t,x)
global OPEuser
%
% $Id: monodGrowth.m 5 2008-11-18 04:11:57Z bjandre $
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

% the monod with growth function
% params(1) muMax
% params(2) = Ks
% params(3) = growth term, X0/Y
muMax = OPEuser.params(1);
Ks = OPEuser.params(2);
growth = OPEuser.params(3);
% S0 = initial substrate conc = constant
s0 = OPEuser.expData(1); 

xdot(1) = -muMax * x(1) * (growth + s0 - x(1)) / (Ks + x(1));
