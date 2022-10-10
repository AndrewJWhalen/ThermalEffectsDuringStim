addpath('../classes/')
load('../init/leak.mat')
addpath('../functions/')


init = leak.init;
tstart = 5000;
last2 = 60*1000;
profile_0 = leak.profile_0;
bath =[leak.bath,1,1];

fin = init;

Q10_list = [3,3,1.75,2.85,1.7,1.7,1,1,1,1,1,3,3];


for i = 1:length(init)
    if i == 11
        fin(i) = 31;
    else
        fin(i) = init(i)*Q10_list(i)^(1/10);
    end
end

tc_list = [1, 5000, 50000, 500000];
last = 500000*8;
ss=1;
dT = 0.1;

pt_cell = cell(4,3);

parfor i = 1:4
    [pt1,ct1] = leak.function_name(profile_0, bath, init, fin, tc_list(i), tstart, last, ss,dT);
    p_0 = pt1(:,end);
    [pt2,ct2] = leak.function_name(p_0, bath, fin, init, tc_list(i), tstart, last, ss,dT);
    pt_send={pt1,pt2,[num2str(tc_list(i)),'ms tc']};
    pt_cell(i,:) = pt_send;
end

save('../results/tc_variation.mat','pt_cell','-v7.3')


