%
% $Id: ode45_EDmodelDSII.m 2 2008-11-18 03:26:48Z bjandre $
%
% ED MODEL*****************************************************************
clear;

% read data
dataFile = 'DSdata.csv';
rawdata = csvread(dataFile);

% Initial conditions for concentrations, y (mol/m3):
y=[67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 67.18; 11.37; 11.37; 11.37; 11.37; 11.37; 67.18; 67.18];
%y=[68.18; 67.754; 68.18; 67.18; 67.18; 67.18; 68.68; 68.528; 68.68; 67.18; 67.18; 67.18; 11.452; 11.37; 11.5; 11.37; 11.37; 67.18; 67.18];

% use time from data for ode
t_exp = rawdata(:,1);

[t,y]= ode45('ode45_EDmodelDSII_eqns', t_exp, y);

% extract the ode data that we want to compare to the exp data
yc_mod=y(:,2)
yd_mod=y(:,8)
yr_mod=y(:,13)

plot (t_exp,yr_mod,t_exp,yc_mod,t_exp,yd_mod);
pause

%experimental data
yc_exp = rawdata(:,2);
yd_exp = rawdata(:,3);
yr_exp = rawdata(:,4);

%plot experimental and model data
plot (t_exp,yr_exp,'x',t_exp,yc_exp,'+',t_exp,yd_exp,'o',t_exp,yr_mod,t_exp,yc_mod,t_exp,yd_mod);
ax = [0 80]; ay = [0 150]; axis ([ax ay]);
xlabel ('test duration');
ylabel ('concentration of sodium ions (mol/m^3)');
legend('yr exp','yc exp','yd exp','yr mod','yc mod','yd mod')
