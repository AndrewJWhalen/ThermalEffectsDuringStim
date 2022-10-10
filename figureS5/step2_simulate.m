addpath('../classes/')
load('../init/leak.mat')
addpath('../functions/')


%% run leak
init = leak.init;
profile_0 = leak.profile_0;
bath =leak.bath;

tstart = 1000;
tc=5000;
ss=0.1;
dT = 0.02;
last = 5000;

fin_list = cell(4,1);
for i = 1:4
    fin = init;
    fin([7,9]) = 3^(1/10);
    fin(8) = fin(8)*(1.4+0.2*i)^(1/10);
    fin_list{i} = fin;   
end


pt_cell = cell(4,1);

parfor i = 1:4
    fin = fin_list{i};
    [pt1,ct1] = leak.function_name(profile_0, bath, init, fin, tc, tstart, last, ss,dT);
    pt_cell{i} = pt1;

end


save('../results/na_l_sweep.mat','pt_cell')

    
