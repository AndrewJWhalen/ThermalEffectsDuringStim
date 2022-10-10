%% n dependency (constnat m,h)

 %load('startingpoint.mat')
 %x=profile_0;
 
switch point
    case 1
        [vset,mnhset]=meshgrid(linspace(-65,-58,xnstep),linspace(0.00,0.15,ynstep));
        [v0list, neq, meq, heq, ~, ~] = equilibrium(profile_0);
    case 3
        [vset,mnhset]=meshgrid(linspace(-42,-40,xnstep),linspace(0.52,0.57,ynstep));
        [v0list, neq, meq, heq, ~, ~] = equilibrium_solve(profile_0);
end



v0 = v0list(1);
h = heq(1);
pump = 1.1;
syms v n

%% parameters
% Basic HH paramters
G_K = 25;G_Na = 30;                    % voltage gated conductance
g_l_cl=0.1;g_l_k=0.05;g_l_na=0.0247*1.5;   % leak conductance
C = 1.0;                               % capacitance representing the lipid bilayer
rho = 0.8;                             % maximal pump rate
% Volume
Vol = 1.4368e-15;                      % unit:m^3, when r=7 um,v=1.4368e-15 m^3;
beta0 = 7;

%% Variables

NKo = profile_0(6);                             % ion unit: mol
NKi = profile_0(7);               
NNao = profile_0(8);
NNai = profile_0(9);  
NClo = profile_0(10);
NCli = profile_0(11);
Voli =profile_0(5);                            % intracellular volume
O = profile_0(12);
Volo = (1+1/beta0)*Vol-Voli;            % extracellular volume

%% ion unit mol to mol/m^3=mmol/L = mM
Ko = NKo/Volo;             
Ki = NKi/Voli;
Nao = NNao/Volo;
Nai = NNai/Voli;
Clo = NClo/Volo;
Cli = NCli/Voli;

alpha = 4*pi*(3*Voli/(4*pi)).^(2/3);  % surface area (m^2)
F = 6.02e23*1.6e-19;                  % F = e*NA      
gamma = alpha/(F*Voli)*1e-2;    % 1e-2: convert from m to cm.  0.0445;% 

%% gating variables
alpha_m =  0.32*(54+v)./(1-exp(-(v+54)/4));
beta_m = 0.28*(v+27)./(exp((v+27)/5)-1);

alpha_h = 0.128*exp(-(50+v)/18);
beta_h = 4./(1+exp(-(v+27)/5));  

alpha_n = 0.032*(v+52)./(1-exp(-(v+52)/5));
beta_n = 0.5*exp(-(v+57)/40);      

m = alpha_m/(alpha_m+beta_m);
% h = alpha_h/(alpha_h+beta_h);
% n = alpha_n/(alpha_n+beta_n);

%% pump, glia and diffusion (mM/s)
p = rho/(1+exp(-(O-20)/3))/gamma;
I_pump = pump*(p/(1.0+exp((25-Nai)/3.0)))*(1.0/(1.0+exp((3.5-Ko)/1)));

%% Reversal potential   
E_K = 26.64 * log(Ko/Ki);
E_Na = 26.64 * log(Nao/Nai);
E_Cl= 26.64 * log(Cli/Clo);    

%% Currents    (uA/cm^2)
INa = G_Na * m^3 * h * (v-E_Na)+ g_l_na * (v-E_Na);
IK = G_K * n^4 * (v-E_K)+ g_l_k* (v-E_K);
IL = g_l_cl * (v-E_Cl);

%% Output for n
dotv = ( -INa - IK  - IL - I_pump)/C;
%dotm = (alpha_m*(1-m)-beta_m*m);
%doth = (alpha_h*(1-h)-beta_h*h);
dotn = (alpha_n*(1-n)-beta_n*n);


u1 = zeros(size(vset));
u2 = u1;
norm1 = u1;
norm2 = u1;
xfact = max(vset,[], 'all')-min(vset,[], 'all');
yfact = max(mnhset,[], 'all')-min(mnhset,[], 'all');



for i = 1:size(vset,1)
    for ii = 1:size(vset,2)
        u1(i,ii) = double(subs(subs(dotv,n,mnhset(i,ii)),v,vset(i,ii)));
        u2(i,ii) = double(subs(subs(dotn,n,mnhset(i,ii)),v,vset(i,ii)));

        norm0 = sqrt((u1(i,ii)/xfact)^2+(u2(i,ii)/yfact)^2);
        norm1(i,ii) = u1(i,ii)/norm0;
        norm2(i,ii) = u2(i,ii)/norm0;
    end
end

%% v nullcline
dvstep = 0.1;
v_nc=[min(vset,[],'all'):dvstep:max(vset,[],'all')]; mnh_nc=[];
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);


for val_x = v_nc
    
    mnh_nc = [mnh_nc,vpasolve(subs(dotv,v,val_x)==0,n)];


end


%% scaled

scalefact = 20;
ylim([min(mnhset,[],'all') max(mnhset,[],'all')])
xlim([min(vset,[],'all') max(vset,[],'all')])
for i = 1:size(vset,1)
    for ii = 1:size(vset,2)
        arrow([vset(i,ii),mnhset(i,ii)],[vset(i,ii)+norm1(i,ii)/scalefact,mnhset(i,ii)+norm2(i,ii)/scalefact],'Length',5,'TipAngle',30)

    end
end


hold on
plot(min(vset,[], 'all'):0.01:max(vset,[], 'all'),subs(alpha_n/(alpha_n+beta_n),v,min(vset,[], 'all'):0.01:max(vset,[], 'all')))
for i = 1:size(mnh_nc,1)
    if isreal(mnh_nc(i,1))
        plot(v_nc,mnh_nc(i,:))
    end
end
hold off


xlabel('V (mV)')
ylabel('n')



