function [v,dv] = getvolume(t)
global OPEuser

%
% $Id: getvolume.m 5 2008-11-18 04:11:57Z bjandre $
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

time = OPEuser.time;
volume = OPEuser.userData(:,1);
deltavol = OPEuser.userData(:,2);

samplinginterval = 30;
vol = volume(1);
dvdt = 0;
[nrows,ncols]=size(time);
for sample=1:nrows-1
    if (time(sample)< t && t <= time(sample)+samplinginterval/2)
        %linearly interpolate volume
        dvdt = -deltavol(sample)/samplinginterval;
        vol = dvdt*(t-time(sample))+(volume(sample)+volume(sample+1))/2;
    elseif (time(sample)+samplinginterval/2 < t && t <= time(sample+1)-samplinginterval/2)
       %volume is constant (i.e. dvdt = 0)
        dvdt = 0;
        vol = volume(sample + 1);
       
    elseif (time(sample+1)-samplinginterval/2 < t && t <= time(sample+1))
        %do something simliar to above
        dvdt = -deltavol(sample+1)/samplinginterval;
        vol = volume(sample+1)+dvdt*(t-(time(sample+1)-samplinginterval/2));
    end
end
v = vol;
dv = dvdt;

