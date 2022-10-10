init_cell = cell(6,6);

for i = 1:6
    for j = 1:6
        init_0 = profile_0_list
        leak = initialdata(profile_0, @main_c_cotrans, [pwd,'/functions/'], bath, init);
    end
end
leak = initialdata(profile_0, @main_c, [pwd,'/functions/'], bath, init);
save('init/leak.mat','leak')



init_cell = cell(6,6,6);

for n = 1:6
    for k = 1:6
        for t = 1:6

            c = profile_t_list{n,k,t};
            c.initialdata.bath(5) = 1-c.initialdata.bath(5);
            c.initialdata.function_name = @main_c_cotrans;
            init_cell{7-n, k, t} = c.initialdata;
        end
    end
end

for n = 1
    for k = 1:6
        for t = 1:6

            if profile_t_list{6,k,t}.profile_t ~= pt_cell{k, t}
                disp('not')
            end

  
%             if init_cell{7-n, k, t}.profile_0~= profile_t_list{n,k,t}.initialdata.profile_0
%                 disp('not')
%             end
% 
%             if init_cell{n, k, t}.bath(5) -(n-1)*0.2 > 0.0001
%                 disp('not2')
%             end
                
              
        end
    end
end

n=1
k=1
t=1



init = ones(13,1);
init(11) = 30;
init(8) = 1.5;
Ko = 6.25;
Nao = 147.4;
Clo = 131.4;
bath = [Ko, 32, Nao, Clo, 0 , 1];
tc = 1;
tstart = 1;
dT=0.05;
last = 5000;
ss = round(last/1000);
tic
[~,~] = main_c_cotrans(profile_0, bath, init, init, tc, tstart, last, ss,dT);
toc