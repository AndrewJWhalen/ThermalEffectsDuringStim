addpath('../classes/')
load('../init/leak.mat')
addpath(leak.function_path)


init = leak.init;
tstart = 5000;
last = 300*1000;
last2 = 300*1000;
ss=0.1;
dT = 0.02;
profile_0 = leak.profile_0;
bath =leak.bath;

fin = init;
Q10_list = [3,3,1.75,2.85,1.7,1.7,1,1,1,1,1,3,3];

for i = 1:length(init)
    if i == 11
        fin(i) = 31;
    else
        fin(i) = init(i)*Q10_list(i)^(1/10);
    end
end

tc = 5000;


[pt1,ct1] = leak.function_name(profile_0, bath, init, fin, tc, tstart, last, ss,dT);
p_0 = pt1(:,end);
[pt2,ct2] = leak.function_name(p_0, bath, fin, init, tc, tstart, last, ss,dT);

pt_cell_all={pt1,pt2};
ct_cell_all = {ct1,ct2};

save('../results/5tc_all.mat','pt_cell_all','ct_cell_all')


