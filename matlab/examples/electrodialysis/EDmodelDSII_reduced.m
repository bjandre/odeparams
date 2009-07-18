%
% $Id: EDmodelDSII_reduced.m 2 2008-11-18 03:26:48Z bjandre $
%
% ED MODEL*****************************************************************
clear;
global t_initial

% read data
dataFile = 'DSdata.csv';
rawdata = csvread(dataFile);

% Initial conditions for concentrations, y (mol/m3):
%y=[68.52; 68.52; 68.52; 68.52; 68.52; 68.52; 11.4; 11.4; 11.4];
%y=[67.754; 67.754; 67.754; 68.52; 68.52; 68.52; 11.4; 11.4; 11.4];
y=[67.8; 67.754; 67.8; 68.4; 68.52; 68.8; 11.4; 11.4; 11.4];


% use time from data for ode
t_exp = rawdata(:,1);
%t_exp = [0.0:0.001:100];
t_initial = t_exp(2);

[t,y]= ode45('EDmodelDSII_reduced_eqns', t_exp, y);

% extract the ode data that we want to compare to the exp data
CcT_mod=y(:,2);
CdT_mod=y(:,5);
CrT_mod=y(:,7);

%experimental data
CcT_exp = rawdata(:,2);
CdT_exp = rawdata(:,3);
CrT_exp = rawdata(:,4);

%plot experimental and model data
plot1 = plot (t_exp,CrT_exp, ...
    t_exp,CrT_mod, ...
    t_exp,CcT_exp, ...
    t_exp,CcT_mod, ...
    t_exp,CdT_exp, ...
    t_exp,CdT_mod);
ax = [0 80]; ay = [0 150]; axis ([ax ay]);
set(plot1(1),'DisplayName','CrT exp','MarkerFaceColor',[1 0 0],'Marker','x','LineStyle','none');
set(plot1(2),'DisplayName','CrT mod','Color',[1 0 0]);
set(plot1(3),'DisplayName','CcT exp','MarkerFaceColor',[0 1 0],'Marker','+','LineStyle','none');
set(plot1(4),'DisplayName','CcT mod','Color',[0 1 0]);
set(plot1(5),'DisplayName','CdT exp','MarkerFaceColor',[0 0 1],'Marker','o','LineStyle','none');
set(plot1(6),'DisplayName','CdT mod','Color',[0 0 1]);
legend(axes1,'show');
xlabel ('test duration');
ylabel ('concentration of sodium ions (mol/m^3)');
