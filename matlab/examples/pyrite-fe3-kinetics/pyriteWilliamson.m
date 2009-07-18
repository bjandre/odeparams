function ydot = pyriteWilliamson(t,y)
global OPEuser
%
% $Id: pyriteWilliamson.m 5 2008-11-18 04:11:57Z bjandre $
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

%ydot(1) = dFe2/dt (mol/sec)
%ydot(2) = dFe3/dt (mol/sec)
%a = exponent of Fe2 concentration
%b = exponent of Fe3 concentration
%k = rate constant
%y(1) refers to the Fe2 column in the data. It denotes a vector. 
%y(2) refers to the Fe3 column in the data.

surfaceArea = OPEuser.userParams;
a = OPEuser.params(1);
b = OPEuser.params(2);
k = OPEuser.params(3);

[v,dv] = getvolume(t);
ydot = zeros(2,1);
ydot(1) = surfaceArea * k * (y(1)/v)^a * (y(2)/v)^b + (y(1)/v)*dv;
ydot(2) = -(14/15) * surfaceArea * k * (y(1)/v)^a * (y(2)/v)^b + (y(2)/v)*dv;
