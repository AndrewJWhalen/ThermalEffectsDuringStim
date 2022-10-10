addpath('../classes/')
addpath('../functions/')

load('../init/kcc2_temp_init.mat')
tc = 1;
tstart = 1;
last = 5000;
ss = 0.1;
dt = 0.05;

pt_cell = cell(6,6); % will sweep for kcc2 and temperature

parfor k = 1:6
    for t = 1:6
        init_d = init_cell{k,t}; 
        [pt1,~]=init_d.function_name(init_d.profile_0, init_d.bath, init_d.init, init_d.init, tc, tstart, last, ss,dT);
        pt_cell{k,t} = pt1;
    end
end

save('../results/kcc2_temp_sweep_2.mat','pt_cell')

