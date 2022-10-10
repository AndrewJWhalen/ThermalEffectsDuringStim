function [r,cur]=model_int_cotrans(x,bath,pump, nmod, mmod, hmod, gnmod, gkmod, leak_k, leak_na, leak_cl, o2D,temp,cotrans1,cotrans2)
%% Parameters
   % Basic HH paramters
   G_K = 25*gkmod;G_Na = 30*gnmod;                    % voltage gated conductance
   g_l_cl=0.1*leak_cl;g_l_k=0.05*leak_k;g_l_na=0.0247*leak_na;   % leak conductance
   C = 1.0;                               % capacitance representing the lipid bilayer

   
   % Ion Concentration related Parameters
   dslp=0.25;                             % potassium diffusion coefficient   
                                          %(https://medicalsciences.med.unsw.edu.au/research/research-services/ies/ionicmobilitytables)
                                          %shows that relative mobility of sodium is 0.682, chloride is  1.0388
                                          % (Liquid junction potentials and small cell effects in patch clamp analysis)
                                          % Barry, Lynch 1991  
   gmag=5;                                % maximal glial strength
   sigma =0.17*o2D;                           % oxygen diffusion coefficient
   Ukcc2 =cotrans2*0.3;                            % maximal KCC2 cotransporter strength
   Unkcc1 =cotrans1*0.1;                           % maximal NKCC1 cotransporter strength
   rho = 0.8;                             % maximal pump rate
   
   % Volume
   Vol = 1.4368e-15;                      % unit:m^3, when r=7 um,v=1.4368e-15 m^3;
   beta0 = 7;
     
   % Time Constant
   tau = 0.001;  
   
   % Changeable Parameters
   Kbath = bath(1);
   Obath = bath(2);
   Nabath = bath(3);
   Clbath = bath(4);
   L_nkcc1 = bath(5);
   L_kcc2 = bath(6);


   
%% Variables
   v = x(1);
   m = x(2);
   h = x(3);
   n = x(4); 
 
   NKo = x(6);                             % ion unit: mol
   NKi = x(7);               
   NNao = x(8);
   NNai = x(9);  
  
   NClo = x(10);
   NCli = x(11);
   
   Voli =x(5);                            % intracellular volume
   
   O = x(12);
   
   if O<=0
       O=0;
   end
   
   Volo = (1+1/beta0)*Vol-Voli;            % extracellular volume
   beta = Voli/Volo;                       % ratio of intracelluar volume to extracelluar volume

   fo = 1.0./(1+exp(-(Obath-2.5)/0.2));
   fv = 1.0/(1+exp((-20+beta)/2));
   dslp = dslp*fo*fv;
   gmag  = gmag*fo;
   
    
%% ion unit mol to mol/m^3=mmol/L = mM
   Ko = NKo/Volo;             
   Ki = NKi/Voli;
   Nao = NNao/Volo;
   Nai = NNai/Voli;
   Clo = NClo/Volo;
   Cli = NCli/Voli;

   
%    global t;
%    if t>1500&t<1540
%         Iext = 2.5;     
%    else
        Iext = 0;
%    end
%    

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

%% pump, glia and diffusion (mM/s)
   p = rho/(1+exp(-(O-20)/3))/gamma;
   I_pump = pump*(p/(1.0+exp((25-Nai)/3.0)))*(1.0/(1.0+exp((3.5-Ko)/1)));
   I_glia = gmag/(1.0 + exp((18.0-Ko)/2.5));
   Igliapump = pump*(p/3/(1.0+exp((25.0-18)/3.0)))*(1.0/(1.0+exp(3.5-Ko)));
   I_diff = dslp*(Ko-Kbath)+I_glia+2*Igliapump*gamma;
   I_diff_Na = 0.682*dslp*(Nao-Nabath)-3*Igliapump*gamma;
   I_diff_Cl = 1.0388*dslp*(Clo-Clbath);


%% Cloride transporter (mM/s)
   fKo = (1/(1+exp((16-Ko)/1)));
   FKCC2 = L_kcc2*Ukcc2*log((Ki*Cli)/(Ko*Clo));
   FNKCC1 = Unkcc1*((1-L_nkcc1)*(fKo-1)+1)*(log((Ki*Cli)/(Ko*Clo))+log((Nai*Cli)/(Nao*Clo)));

%% Reversal potential   

   E_f = 0.08617;
   E_K = E_f*(temp+273.15) * log(Ko/Ki);
   E_Na = E_f*(temp+273.15) * log(Nao/Nai);
   E_Cl= E_f*(temp+273.15) * log(Cli/Clo);   
   
%% Currents    (uA/cm^2)
   INa = G_Na * m^3 * h * (v-E_Na)+ g_l_na * (v-E_Na);
   IK = G_K * n^4 * (v-E_K)+ g_l_k* (v-E_K);
   IL = g_l_cl * (v-E_Cl);
   
%% Output
   dotv = ( -INa - IK  - IL - I_pump + Iext)/C;
   dotm = mmod*(alpha_m*(1-m)-beta_m*m);
   doth = hmod*(alpha_h*(1-h)-beta_h*h);
   dotn = nmod*(alpha_n*(1-n)-beta_n*n);
 
   dotNKo =  tau*(gamma*beta*(IK -  2.0 * I_pump) -I_diff + FKCC2*beta + FNKCC1*beta)*Volo; 
   dotNKi =  tau*(-gamma*(IK - 2.0*I_pump) - FKCC2 - FNKCC1)*Voli;

   dotNNao = tau*(gamma*beta*(INa + 3.0*I_pump)+FNKCC1*beta-I_diff_Na)*Volo;
   dotNNai = tau*(-gamma*(INa + 3.0 * I_pump)-FNKCC1)*Voli; 

   dotNCli = tau*(gamma*IL - FKCC2 -2*FNKCC1)*Voli;
   dotNClo = tau*(-gamma*beta*IL+ FKCC2*beta + 2*FNKCC1*beta-I_diff_Cl)*Volo;
   
   % intracellular volume dynamics
   r1 = Vol/Voli;
   r2 = 1/beta0*Vol/((1+1/beta0)*Vol-Voli);
   Ai = 132+(Nabath-144)+(Clbath-130)+(Kbath-4);
   Ao = 18;
   pii = Nai+Cli+Ki+Ai*r1;
   pio = Nao+Ko+Clo+Ao*r2;
   
   Vol_hat = Vol*(1.1029-0.1029*exp((pio-pii)/20));
   dotVoli = -(Voli-Vol_hat)/0.25*tau;  

   % oxygen dynamics
   dotO = tau*(-5.3*(I_pump+Igliapump)*gamma+sigma*(Obath-O));
   
   r = [dotv;dotm;doth;dotn;dotVoli;dotNKo;dotNKi;dotNNao;dotNNai;dotNClo;dotNCli;dotO];
   
   %pump, Na channel, K channel, Na leak, K leak, CL leak, all in uA/cm^2
   %positive current is outward
   
   cur = zeros(6,1);
   cur(1) = I_pump;
   cur(2) = G_Na * m^3 * h * (v-E_Na);
   cur(3) = G_K * n^4 * (v-E_K);
   cur(4) = g_l_na * (v-E_Na);
   cur(5) = g_l_k* (v-E_K);
   cur(6) = IL;
   cur(7) = 1/(1+exp(-(O-20)/3));
   cur(8) = 1/(1.0+exp((25-Nai)/3.0));
   cur(9) = 1.0/(1.0+exp((3.5-Ko)/1));
%    cur(7) = FNKCC1/gamma;
%    cur(8) = FKCC2/gamma;
end
