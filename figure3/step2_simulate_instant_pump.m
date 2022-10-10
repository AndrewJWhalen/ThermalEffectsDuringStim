addpath('classes/')
addpath('results/')
load('init/leak.mat')
addpath(leak.function_path)

tc = 1;
init = leak.init;
tstart = 5000;
last = 180*1000;
last2 = 60*1000;
ss=0.1;
dT = 0.02;
profile_0 = leak.profile_0;
bath =leak.bath;

fin_pump_only=init;
fin_pump_only(1) = 1.1;

[pt1,ct1] = leak.function_name(profile_0, bath, init, fin_pump_only, tc, tstart, last, ss,dT);
p_0 = pt1(:,end);
[pt2,ct2] = leak.function_name(p_0, bath, fin_pump_only, init, tc, tstart, 60*1000, ss,dT);

pt_cell_inst={pt1,pt2};
ct_cell_inst={ct1,ct2};

save('results/instant_pump.mat','pt_cell_inst','ct_cell_inst')

