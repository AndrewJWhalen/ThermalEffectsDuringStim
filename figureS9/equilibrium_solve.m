%input: profile t

%output: eq points and stability at those points.

%also want something where i can graph dvdot/dt as function of the 4 variables

function [veq, neq, meq, heq, stability, dotv] = equilibrium_solve(profile_0)
    
    pump = 1.1;
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
   syms v

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
   h = alpha_h/(alpha_h+beta_h);
   n = alpha_n/(alpha_n+beta_n);

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
   
%% Output
   dotv = ( -INa - IK  - IL - I_pump)/C;

   veq = vpasolve(dotv==0,v);
   
  
    
   meq = double(subs(m,v,veq));  
   heq = double(subs(h,v,veq));  
   neq = double(subs(n,v,veq));  
   
   %% stability

      doubledotv=diff(dotv);
      stability = sign(double(subs(doubledotv,v,veq)));
   
end
