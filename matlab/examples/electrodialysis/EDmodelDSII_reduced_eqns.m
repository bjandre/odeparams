function dydt=EDmodelDSII_reduced_eqns(t,y)
global t_initial
%%
% Version control: $Id: EDmodelDSII_reduced_eqns.m 2 2008-11-18 03:26:48Z bjandre $
%

%%
%
% Description of unknowns:
% y(1) = Cc,3k (outlet from C conv'l compartment and inlet to C tank)
% y(2) = Cc,T (outlet from C tank and inlet to C compartments)
% y(3) = Cc,Ak (outlet from C compartment by anode and inlet to C tank)
% y(4) = Cd,3k (outlet from D conv'l compartment and inlet to D tank)
% y(5) = Cd,T (outlet from D tank and inlet to D compartments)
% y(9) = Cd,CAk (outlet from D compartment by cathode and inlet to D tank)
% y(7) = Cr,T (outlet from R tank and inlet to anode R)
% y(8) = Cr,Ak (outlet from anode R and inlet to cathode R)
% y(9) = Cr,CAk (outlet from cathode R and inlet to R tank)
%
% intermediate concentrations
%
% Ccc,3k (boundary layer in C conv'l compartment by CMV)    
% Cca,3k (boundary layer in C compartment by AMV)
% Ccc,Ak (boundary layer in C compartment by anode by CMV)
%
% Cdc,3k (boundary layer in D conv'l compartment by CMV)
% Cda,3k (boundary layer in D conv'l compartmnt by AMV)
% Cdc,CAk (boundary layer in D comparment by cathode by CMV)
%
% Crc,CAk (boundary layer in cathode R by CMV)
% Crc,Ak (boundary layer in anode R by CMV)
% Cca,Ak boundary layer in C compartment (by anode) by AMV
% Cda,CAk boundary layer in D compartment (by cathode) by AMV

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
dydt=zeros(size(y));

%%
%
% unknown concentrations
%
Cc3k = y(1);
CcT = y(2);
CcAk = y(3);

Cd3k = y(4);
CdT = y(5);
CdCAk = y(6);

CrT = y(7);
CrAk = y(8);
CrCAk = y(9);

%%
% calculate the tank concentrations
%

% Cc,T : paper eq 3
dydt(2)  = (Qc/Vt/N)*( CcAk + (N-1)*Cc3k - N*CcT );
% Cd,T : paper eq 4
dydt(5)  = (Qd/Vt/N)*( CdCAk + (N-1)*Cd3k - N*CdT );
% Cr,T : paper eq 5 
dydt(7) = (Qr/Vt)*(CrCAk - CrT);

%%
% calculate the current efficiencies
%
if (t < t_initial)
    phi_3k = 1;
    phi_r = 1;
else
%    phi_3k = 0.5 * (dydt(2) + dydt(5)) * CE; %current efficiency for concentrate and dulate
    phi_3k = dydt(2) * CE; %current efficiency for concentrate and dulate
    phi_r = dydt(7) * CE; %current efficiency for rinse
end

% if (phi_3k < 0 || phi_3k > 1)
%     phi_3k = 0.5;
% end
% if (phi_r < 0 || phi_r > 1)
%     phi_r = 0.5;
% end
% phi_3k
% phi_r

%%
%
% calculated boundary layer concentrations
%

% Ccc,3k : paper eq 16
Ccc3k  = (1-tc)*phi_3k*I / (z*F*kmc*A) + Cc3k;
% Cca,3k : paper eq 18
Cca3k  = (1-ta)*phi_3k*I / (z*F*kmc*A) + Cc3k;
% Ccc,Ak : paper eq 20
CccAk  = (1-tc)*phi_r*I / (z*F*kmc*A) + CcAk;

% Cdc,3k : paper eq 17
Cdc3k = -(1-tc)*phi_3k*I / (z*F*kmd*A) + Cd3k;
% Cda,3k : paper eq 19
Cda3k = -(1-ta)*phi_3k*I / (z*F*kmd*A) + Cd3k;
% Cdc,CAk : paper eq 22
CdcCAk = -(1-tc)*phi_r*I / (z*F*kmd*A) + CdCAk;

% Crc,CAk : paper eq 23
CrcCAk = (1-tc)*phi_r*I / (z*F*kmr*A) + CrCAk;
% Crc,Ak : paper eq 21
CrcAk = -(1-tc)*phi_r*I / (z*F*kmr*A) + CrAk;
% Cca,Ak : paper eq 24
CcaAk = (1-ta)*phi_3k*I / (z*F*kmc*A) + CcAk;
% Cda,CAk : paper eq 25
CdaCAk = -(1-ta)*phi_3k*I / (z*F*kmd*A) + CdCAk;


%%
% concentrate equations
%

% Cc,3k : paper eq 9
dydt(1)  = (1/Vk) * (Qc*(N-1)*(CcT - Cc3k)/N + I*phi_3k*(tc - (1 - ta))/(z*F) - A*Kmc*(Ccc3k - Cdc3k) - A*Kma*(Cca3k - Cda3k));
% Cc,Ak : paper eq 11
dydt(3)  = (1/Vk) * (Qc*(CcT - CcAk)/N + I*(phi_r*tc - phi_3k*(1-ta))/(z*F) - A*Kmc*(CccAk - CrcAk) - A*Kma*(CcaAk - Cda3k)); 

%%
% diluate
%

% Cd,3k : paper eq 10
dydt(4)  = (1/Vk) * (Qd*(N-1)*(CdT - Cd3k)/N - I*phi_3k*(tc - (1-ta))/(z*F) - A*Kmc*(Cdc3k - Ccc3k) - A*Kma*(Cda3k - Cca3k));
% Cd,CAk : paper eq 12
dydt(6)  = (1/Vk) * (Qd*(CdT - CdCAk)/N - I*(phi_r*tc - phi_3k*(1-ta))/(z*F) - A*Kmc*(CdcCAk - CrcCAk) - A*Kma*(CdaCAk - Cca3k));

%%
% rinse
%

% Cr,Ak : paper eq 13
dydt(8) = (1/Vkr) * (Qr*(CrT - CrAk) - tc*phi_r*I/(z*F) - A*Kmc*(CrcAk - CccAk) );
% Cr,CAk : paper eq 14
dydt(9) = (1/Vkr) * (Qr*(CrAk - CrCAk) + tc*phi_r*I/(z*F) - A*Kmc*(CrcCAk - CdcCAk) );

%%
% debugging stuff
%

% y
% dydt
% pause
% Ccc3k
% Cca3k
% CccAk
% Cdc3k
% Cda3k
% CdcCAk
% CrcCAk
% CrcAk
% CcaAk
% CdaCA
