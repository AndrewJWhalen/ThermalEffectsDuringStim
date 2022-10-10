addpath('functions/')
addpath('classes/')
addpath('init/')
load('init/init_wei.mat')
Voli = 1.4368e-15; 
Volo = Voli/7;

Ko = 6.25;
Nao = 147.4;
Clo = 131.4;
bath = [Ko, 32, Nao, Clo,];

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
[p1,~]=main_c(profile_00, bath, init, init, tc, tstart, last, ss,dT);


profile_0 = p1(:,end);
save('init/leak_init.mat','profile_0')

leak = initialdata(profile_0, @main_c, [pwd,'/functions/'], bath, init);
save('init/leak.mat','leak')