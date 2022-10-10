
function [profile_t,current_t] = main_c(profile_0, bath, init, fin, tc, tstart, last, ss,dT)


    % dT = 0.02;                     % integration step in ms
    %last = 150000;%15
    
    % ss is sampling step
    
    ns = fix(ss/dT);
    
    p0 = init(1);
    n0 = init(2);
    m0 = init(3);
    h0 = init(4);
    gk0 = init(5);
    gn0 = init(6);
    leak_k0 = init(7);
    leak_na0 = init(8);
    leak_cl0 = init(9);
    o2D0 = init(10);
    temp0 = init(11);
    cotrans10 = init(12);
    cotrans20 = init(13);
    
    pf = fin(1);
    nf = fin(2);
    mf = fin(3);
    hf = fin(4);
    gkf = fin(5);
    gnf = fin(6);
    leak_kf = fin(7);
    leak_naf = fin(8);
    leak_clf = fin(9);
    o2Df = fin(10);
    tempf = fin(11);
    cotrans1f = fin(12);
    cotrans2f = fin(13);

    profile_t = zeros(12, last/ss+1);
    current_t = zeros(9, last/ss);
    profile_t(:,1) = profile_0;
    i = 1;

    %% Simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    xn = profile_t(:,1);
    ttstart = fix(tstart/dT);  %number of time steps for tstart
    ttc = fix(tc/dT);      %number of time steps corresponding to tc
    
    for t = 1:last/dT


        if t < ttstart
            pump = p0;
            nmod = n0;
            mmod = m0;
            hmod = h0;
            gnmod = gn0;
            gkmod = gk0;
            leak_k = leak_k0;
            leak_na = leak_na0;
            leak_cl = leak_cl0;
            o2D = o2D0;
            temp = temp0;
            cotrans1 = cotrans10;
            cotrans2 = cotrans20;
            
            
        elseif t-ttstart < 10*ttc
            pump = p0*((pf/p0)^(1-exp(-(t-ttstart)/ttc)));
            nmod = n0*((nf/n0)^(1-exp(-(t-ttstart)/ttc)));
            mmod = m0*((mf/m0)^(1-exp(-(t-ttstart)/ttc)));
            hmod = h0*((hf/h0)^(1-exp(-(t-ttstart)/ttc)));            
            gnmod = gn0*((gnf/gn0)^(1-exp(-(t-ttstart)/ttc)));
            gkmod = gk0*((gkf/gk0)^(1-exp(-(t-ttstart)/ttc)));
            leak_k = leak_k0*((leak_kf/leak_k0)^(1-exp(-(t-ttstart)/ttc)));
            leak_na = leak_na0*((leak_naf/leak_na0)^(1-exp(-(t-ttstart)/ttc)));
            leak_cl = leak_cl0*((leak_clf/leak_cl0)^(1-exp(-(t-ttstart)/ttc)));
            o2D = o2D0*((o2Df/o2D0)^(1-exp(-(t-ttstart)/ttc)));
            temp = temp0+(tempf-temp0)*(1-exp(-(t-ttstart)/ttc));
            cotrans1 = cotrans10*((cotrans1f/cotrans10)^(1-exp(-(t-ttstart)/ttc)));
            cotrans2 = cotrans20*((cotrans2f/cotrans20)^(1-exp(-(t-ttstart)/ttc)));
            
        else
            pump = pf;
            nmod = nf;
            mmod = mf;
            hmod = hf;
            gnmod = gnf;
            gkmod = gkf;
            leak_k = leak_kf;
            leak_na = leak_naf;
            leak_cl = leak_clf;
            o2D = o2Df;
            temp = tempf;
            cotrans1 = cotrans1f;
            cotrans2 = cotrans2f;
        end
    

        [k1,i1] = model_int(xn, bath, pump, nmod, mmod, hmod, gnmod, gkmod, leak_k, leak_na, leak_cl,o2D,temp,cotrans1,cotrans2);               % Runge-Kutta Method
        [k2,i2] = model_int(xn+dT/2*k1,bath,pump, nmod, mmod, hmod, gnmod, gkmod, leak_k, leak_na, leak_cl,o2D,temp,cotrans1,cotrans2);
        [k3,i3] = model_int(xn+dT/2*k2,bath,pump,nmod, mmod, hmod, gnmod, gkmod, leak_k, leak_na, leak_cl,o2D,temp,cotrans1,cotrans2);
        [k4,i4] = model_int(xn+dT*k3,bath,pump, nmod, mmod, hmod, gnmod, gkmod, leak_k, leak_na, leak_cl,o2D,temp,cotrans1,cotrans2);
        xn = xn + dT/6*(k1+2*k2+2*k3+k4);
        cur = (i1+2*i2+2*i3+i4)/6;
        
        if mod(t,ns) ==0
            profile_t(:,i+1) = xn;
            current_t(:,i) = cur;
            i = i+1;
        end
    end

end
