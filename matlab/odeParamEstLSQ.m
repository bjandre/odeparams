function residual = odeParamsEstLSQ(params)
global OPEuser
%
% $Id: odeParamEstLSQ.m 5 2008-11-18 04:11:57Z bjandre $
%
% Purpose: generic user supplied least squares function
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

% set the estimated parameters for the user ode function
OPEuser.params = params;

[T, odefit] = ode45(OPEuser.odeFunc, OPEuser.time, OPEuser.ic, OPEuser.odeOptions);

residual = OPEuser.expData - odefit;

[nrows, ncols] = size(odefit);
for sample = 1:nrows
    for depvar = 1:ncols
    residual(sample,depvar) = residual(sample,depvar)*OPEuser.weight(sample,depvar);
    end
end
