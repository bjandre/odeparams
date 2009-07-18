function dydt=ode45_EDmodelDSII_eqns(t,y)
%%
% Version control: $Id: ode45_EDmodelDSII_eqns.m 2 2008-11-18 03:26:48Z bjandre $
%

%%
%
% Description of unknowns:
% y(1) = Cc,3k (outlet from C conv'l compartment and inlet to C tank)
% y(2) = Cc,T (outlet from C tank and inlet to C compartments)
% y(3) = Cc,Ak (outlet from C compartment by anode and inlet to C tank)
% y(4) = Ccc,3k (boundary layer in C conv'l compartment by CMV)    
% y(5) = Cca,3k (boundary layer in C compartment by AMV)
% y(6) = Ccc,Ak (boundary layer in C compartment by anode by CMV)
% y(7) = Cd,3k (outlet from D conv'l compartment and inlet to D tank)
% y(8) = Cd,T (outlet from D tank and inlet to D compartments)
% y(9) = Cd,CAk (outlet from D compartment by cathode and inlet to D tank)
% y(10) = Cdc,3k (boundary layer in D conv'l compartment by CMV)
% y(11) = Cda,3k (boundary layer in D conv'l compartmnt by AMV)
% y(12) = Cdc,CAk (boundary layer in D comparment by cathode by CMV)
% y(13) = Cr,T (outlet from R tank and inlet to anode R)
% y(14) = Cr,Ak (outlet from anode R and inlet to cathode R)
% y(15) = Cr,CAk (outlet from cathode R and inlet to R tank)
% y(16) = Crc,CAk (boundary layer in cathode R by CMV)
% y(17) = Crc,Ak (boundary layer in anode R by CMV)
% y(18) = Cca,Ak boundary layer in C compartment (by anode) by AMV
% y(19) = Cda,CAk boundary layer in D compartment (by cathode) by AMV

%%
%
%****Constants for ED model****:
%
I=0.02; % Current (A) 
F=96484/3600; % Faraday's constant (A*h/eq) = F 
N=4; % Number of cell pairs = N 
Qr=0.0066; % Flowrate (m^3/h)= Qr 
Qd=0.0071; % Flowrate (m^3/h)= Qd
Qc=0.0067; % Flowrate (m^3/h)= Qc
A=0.0064; % Active area of membrane (m^2)= A 
TF=I/(A*F); % Theoretical flux

% Mass transfer coefficent through boundary layer by each membrane (m/h) = km 
% km = Sh*D/b 
Rer=11.5; % Re = Reynold's number (from middle of channel)
Red=12.25;
Rec=11.5; 
Sc=662.1; % Sc = Schmidt number for NaCl
% Sh = Sherwood's number = B*(Re^c*Sc^d)
B = 0.53;
c = 0.5;
d = 1/3;
Shr= B*((Rer^c)*(Sc^d)); 
Shd= B*((Red^c)*(Sc^d)); 
Shc= B*((Rec^c)*(Sc^d)); 
Db=0.000005798; % Diffusivity of NaCl in bulk solution at 25C (m2/h) = Db 
b=0.000053; % Boundary layer thickness (m) = b (Assumption from Moon et al, 2003)
kmr= Shr*Db/b; % Rinse
kmd= Shd*Db/b; % Diluate
kmc= Shc*Db/b; % Concentrate

h=0.0005 ; % Concentrate and diluate compartment thickness (m) = h 
hr=0.001 ; % Rinse compartment thickness (m) = hr 

bc=0.00014; % Thickness of CMV (m) = bc 
ba=0.000135; % Thickness of AMV (m) = ba 

% Mass transfer coefficent 'through' membrane = Km 
Kmc = 0.0000049; % Kmc 
Kma = 0.000000569; % Kma 

z=1 ; % Absolute value of valency of sodium ion (eq/mol) = z

tc=0.92; % Transport number in CMV 
ta=0.94; % Transport number in AMV

Vt=0.001; % Volume of tanks (m3)
Vk=h*A ; % Volume of concentrate and dilutate compartments (m3) = Vk
Vkr=hr*A; % Volume of rinse compartments (m3) = Vkr 
CE=Vt/(A*N*TF); %Current efficency constant

% resize the vector so matlab doesn't complain about dimensions
dydt=zeros(19,1);

%%
% calculate the current efficiencies
%

% Cc,T : paper eq 3
dydt(2)  = (Qc/Vt/N)*( y(3) + (N-1)*y(1) - N*y(2) );
% Cd,T : paper eq 4
dydt(8)  = (Qd/Vt/N)*( y(9) + (N-1)*y(7) - N*y(8) );
% Cr,T : paper eq 5 
dydt(13) = (Qr/Vt)*(y(15) - y(13));

phi_c = dydt(2) * CE %current efficiency for concentrate
phi_d = dydt(8) * CE %current efficiency for diluate
phi_r = dydt(13) * CE %current efficiency for rinse

%%
% concentrate equations?
%

% Cc,3k : paper eq 7
dydt(1)  = (1/Vk) * (-(-phi_c*tc*I/(z*F)) - phi_c*(1-ta)*I/(z*F) - (A*Kmc*(y(4) - y(10))) - (A*Kma*(y(5) - y(11))));
% Cc,Ak : paper eq 9
dydt(3)  = (1/Vk) * (-(-phi_c*tc*I/(z*F)) - phi_c*(1-ta)*I/(z*F) - (A*Kmc*(y(6) - y(17))) - (A*Kma*(y(18) - y(11)))); 
% Ccc,3k : paper eq 14
dydt(4)  = -phi_c*I*(1-tc) / (z*F*kmc*A) + y(1);
% Cca,3k : paper eq 16
dydt(5)  = phi_c*I*(1-ta) / (z*F*kmc*A) + y(1);
% Ccc,Ak : paper eq 18
dydt(6)  = -phi_c*I*(1-tc) / (z*F*kmc*A) + y(3);

%%
% diluate?
%

% Cd,3k : paper eq 8
dydt(7)  = (1/Vk) * (-phi_d*tc*I/(z*F) - (-phi_c*(1-ta)*I/(z*F)) - A*Kmc*(y(10) - y(4)) - A*Kma*(y(11) - y(5)));
% Cd,CAk : paper eq 10
dydt(9)  = (1/Vk) * (-phi_d*tc*I/(z*F) - (-phi_d*(1-ta)*I/(z*F)) - A*Kmc*(y(12) - y(16)) - A*Kma*(y(19) - y(5)));
% Cdc,3k : paper eq 15
dydt(10) = -phi_d*I*(1-tc) / (z*F*kmd*A) + y(7);
% Cda,3k : paper eq 17
dydt(11) = -phi_d*I*(1-ta) / (z*F*kmd*A) + y(7);
% Cdc,CAk : paper eq 20
dydt(12) = -phi_d*I*(1-tc) / (z*F*kmd*A) + y(9);

%%
% rinse?
%

% Cr,Ak : paper eq 11
dydt(14) = (1/Vkr) * ( -tc*phi_r*I/(z*F) - A*Kmc*(y(17) - y(6)) );
% Cr,CAk : paper eq 12
dydt(15) = (1/Vkr) * (phi_r*tc*I/(z*F) - A*Kmc*(y(16) - y(12)) );
% Crc,CAk : paper eq 21
dydt(16) = -phi_r*I*(1-tc) / (z*F*kmr*A) + y(15);
% Crc,Ak : paper eq 19
dydt(17) = -phi_r*I*(1-tc) / (z*F*kmr*A) + y(14);
% Cca,Ak : paper eq 22
dydt(18) = phi_c*I*(1-ta) / (z*F*kmc*A) + y(3);
% Cda,CAK : paper eq 23
dydt(19) = -phi_d*I*(1-ta) / (z*F*kmd*A) + y(9);

% debugging stuff
y
dydt
%pause
