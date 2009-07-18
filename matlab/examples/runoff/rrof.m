function xdot=rrof(t,x)
global OPEuser
% $Id: rrof.m 2 2008-11-18 03:26:48Z bjandre $
%functions for the rainfall runoff model 
%parameter values
ku=OPEuser.params(1);kp=OPEuser.params(2);kl=OPEuser.params(3);
um=OPEuser.params(4);lm=OPEuser.params(5);tc=OPEuser.params(6);
%get the precipitation value
p=0.0;
if (t>2) && (t<=3)
    p=5.0;
end
if (t>3) && (t<=4)
    p=8.0;
end
%
if (t>4) && (t<=5)
    p=3.0;
end
%
if (t>5) && (t<=6)
    p=1.0;
end
%
if (t>9) && (t<=10)
    p=3.0;
end
%
if (t>10) && (t<=11)
    p=5.0;
end
%
if (t>11) && (t<=12)
    p=12.0;
end
%
if (t>12) && (t<=13)
    p=6.0;
end
%
if (t>13) && (t<=14)
    p=1.0;
end
%
%let u=x(1) and l=x(2), find overland flow and d/dt's
u=x(1);l=x(2);
if u > um
    r=(u-um)/tc;
else
    r=0;
end
dudt=-ku*u-kp*(1-(l/lm)^3)*u+p-r;
dldt=kp*(1-(l/lm)^3)*u-kl*l;
runoff=ku*u+kl*l+r;
xdot=[dudt;dldt;r;runoff];
%this is the command for using this function with an ODE solver
%[tvec,xsol]=ode45('rrof',[0 20],[9.0,12.0,0.0,0.0])