addpath('functions/')
addpath('classes/')
load('init/init_wei.mat')
Voli = 1.4368e-15; 
Volo = Voli/7;

Ko = 6.25;
Nao = 147.4;
Clo = 131.4;
bath = [Ko, 32, Nao, Clo, 0 , 1];

profile_00 = transpose(profile_0);
profile_00(6) = Ko*Volo;
profile_00(8) = Nao*Volo;
profile_00(10) = Clo*Volo;


init = ones(13,1);
init(11) = 30;
init(8) = 1.5;

tc = 1;
tstart = 1;
dT=0.05;
last = 3000000;
ss = round(last/1000);


bathlist = cell(6,1);
for k = 1:6
    bathlist{k} = bath;
    bathlist{k}(6) = 0.2*(k-1);
end


initlist = cell(6,1);
Q10_list = [3,3,1.75,2.85,1.7,1.7,1,1,1,1,1,3,3];
for t = 1:6
    fin = init;
    for i = 1:length(init)
        if i == 11
            fin(i) = 34+t;
        else
            fin(i) = init(i)*Q10_list(i)^((4+t)/10); 
        end
    end
    initlist{t} = fin;
end

kt_list = cell(36,1);
for k = 1:6
    for t = 1:6
        kt_list{6*(k-1)+t} = [k,t];
    end
end

p0_list = cell(36);

parpool(36)

parfor i = 1:36
    k = kt_list{i}(1);
    t = kt_list{i}(2);
    [p1,~]=main_c_cotrans(profile_00, bathlist{k}, initlist{t}, initlist{t}, tc, tstart, last, ss,dT);
    p0_list{i} = p1(:,end);
end

init_cell = cell(6,6);
for i = 1:36
    k = kt_list{i}(1);
    t = kt_list{i}(2);
    init_cell{k,t} = initialdata(p0_list{i}, @main_c_cotrans, '../functions/', bathlist{k}, initlist{t});
end


save('init/kcc2_temp_init.mat','init_cell')