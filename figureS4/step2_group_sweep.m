addpath('classes/')
load('init/leak.mat')
addpath(leak.function_path)


%% run leak
init = leak.init;
profile_0 = leak.profile_0;
bath =leak.bath;

tstart = 5000;
tc=1;
ss=0.1;
dT = 0.02;
last = 60000;

group_par_sweep_list= cell(3,1); % i1 =sweep magnitute, 
tlist = [31,32,35];
multlist = [1.05,1.1,1.4];

%     p0 = init(1);
%     n0 = init(2);
%     m0 = init(3);
%     h0 = init(4);
%     gk0 = init(5);
%     gn0 = init(6);
%     leak_k0 = init(7);
%     leak_na0 = init(8);
%     leak_cl0 = init(9);
%     o2D0 = init(10);
%     temp0 = init(11);
%     cotrans10 = init(12);
%     cotrans20 = init(13);


groups = {[2,3,4],[5,6],[7,8,9],[12,13]};
group_par_sweeps = cell(4,3,2); %group, change level, simulation front/back

for ii = 1:3 %level
    fin_list = cell(4,1);
    for iii = 1:4 %group
        fin = leak.init;
        for i = groups{iii}
            if i == 10
            elseif i == 11
                fin(11) = tlist(ii);
            else
                fin(i) = fin(i)*multlist(ii);
            end
            fin_list{iii} = fin;
        end
    end
    
    parfor iii = 1:4
        [pt1,ct1] = leak.function_name(profile_0, bath, init, fin_list{iii}, tc, tstart, last, ss,dT);
        p_0 = pt1(:,end);
        [pt2,ct2] = leak.function_name(p_0, bath, fin_list{iii}, init, tc, tstart, last, ss,dT);
        pt_send={pt1,pt2};
        group_par_sweeps(iii,ii,:) = pt_send;

    end


end

save('results/group_par_sweep.mat','group_par_sweeps')

