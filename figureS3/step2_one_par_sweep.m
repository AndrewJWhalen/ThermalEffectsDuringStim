addpath('../classes/')
load('../init/leak.mat')
addpath('../functions/')


%% run leak
init = leak.init;
profile_0 = leak.profile_0;
bath =leak.bath;

tstart = 5000;
tc=1;
ss=0.1;
dT = 0.02;
last = 60000;


sweeps_by_par = cell(13,1); %parameter
fin_list = cell(13,1);
for i = 1:13       
    fin = init;
    if i == 10
    elseif i == 11
        fin(11) = 31;
        fin_list{i} = fin;
    else
        fin(i) = fin(i)*1.05;
        fin_list{i} = fin;
    end
end

pt_cell = cell(13,2);
parfor i = 1:13
    fin = fin_list{i};
    if ~isempty(fin)
            [pt1,ct1] = leak.function_name(profile_0, bath, init, fin, tc, tstart, last, ss,dT);
            p_0 = pt1(:,end);
            [pt2,ct2] = leak.function_name(p_0, bath, fin, init, tc, tstart, last, ss,dT);
            pt_send={pt1,pt2};
            pt_cell(i,:) = pt_send;

    end
end



save('../results/one_par_sweep.mat','pt_cell')

    

