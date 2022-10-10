addpath('../classes/')
f1 =figure;

fast = load('../results/instant_pump.mat');
slow = load('../results/5tc_all.mat');

%% v
subplot(3,4,2)
plot(-5+0.0001:0.0001:20,fast.pt_cell_inst{1}(1,1:250000))
xlabel('Time (s)')
ylabel('V (mv)')

subplot(3,4,4)
plot(-5+0.0001:0.0001:20,fast.pt_cell_inst{2}(1,1:250000))
xlabel('Time (s)')
ylabel('V (mv)')


%% current
subplot(3,4,6)
norm_f = mean(fast.ct_cell_inst{1}(1,1:50000));
plot(-5+0.0001:0.0001:20,fast.ct_cell_inst{1}(1,1:250000)/norm_f)
xlabel('Time (s)')
ylabel({'Normalized','Pump Current'})

subplot(3,4,8)
norm_f = mean(fast.ct_cell_inst{2}(1,1:50000));
plot(-5+0.0001:0.0001:20,fast.ct_cell_inst{2}(1,1:250000)/norm_f)
xlabel('Time (s)')
ylabel({'Normalized','Pump Current'})

%% vdot instant

addpath('../functions/dotvmapping')

param = ones(10,1);
param(8) = 1.5;
param(1) = 1.1;

cmap = jet(length(50000:10000:250000));
count=1;
subplot(3,4,10)
for i = 50000:10000:250000
    profile_0 = fast.pt_cell_inst{1}(:,i);
    dotv_v = dotvplot(profile_0,[-65 -58],param,30);
    plot(-65:0.1:-58,dotv_v,'Color',cmap(count,:)); hold on
    count = count+1;
end
plot([-65 -58],[0 0],'k')
xlim([-65 -58])

profile_0 = fast.pt_cell_inst{1}(:,50000);
bparam = ones(10,1);
bparam(8) = 1.5;
dotv_v = dotvplot(profile_0,[-65 -58],bparam,30);
plot(-65:0.1:-58,dotv_v,'Color','k')
hold off

xlabel('Voltage (mV)')
ylabel('dV/dt (V/s)')

colormap('jet')
caxis([0 20])


%% instant cooling vdot

count=1;
bparam = ones(10,1);
bparam(8) = 1.5;
subplot(3,4,12)
for i = 50000:10000:250000
    profile_0 = fast.pt_cell_inst{2}(:,i);
    dotv_v = dotvplot(profile_0,[-65 -58],bparam,30);
    plot(-65:0.1:-58,dotv_v,'Color',cmap(count,:)); hold on
    count = count+1;
end
plot([-65 -58],[0 0],'k')
xlim([-65 -58])

profile_0 = fast.pt_cell_inst{2}(:,50000);
dotv_v = dotvplot(profile_0,[-65 -58],bparam,31);
plot(-65:0.1:-58,dotv_v,'Color','k')
hold off

xlabel('Voltage (mV)')
ylabel('dV/dt (V/s)')

colormap('jet')
caxis([0 20])


%% slow, everything

%% v
subplot(3,4,1)
plot(-5+0.0001:0.0001:20,slow.pt_cell_all{1,1}(1,1:250000))
xlabel('Time (s)')
ylabel('V (mv)')

subplot(3,4,3)
plot(-5+0.0001:0.0001:20,slow.pt_cell_all{1,2}(1,1:250000))
xlabel('Time (s)')
ylabel('V (mv)')


%% current
subplot(3,4,5)
norm_f = mean(slow.ct_cell_all{1,1}(1,1:50000));
plot(-5+0.0001:0.0001:20,slow.ct_cell_all{1,1}(1,1:250000)/norm_f)
xlabel('Time (s)')
ylabel({'Normalized','Pump Current'})

subplot(3,4,7)
norm_f = mean(slow.ct_cell_all{1,2}(1,1:50000));
plot(-5+0.0001:0.0001:20,slow.ct_cell_all{1,2}(1,1:250000)/norm_f)
xlabel('Time (s)')
ylabel({'Normalized','Pump Current'})

%% vdot 
init = ones(11,1);
init(8) = 1.5;
init(11) = 30;
tc=5;

Q10_list = [3,3,1.75,2.85,1.7,1.7,1,1,1,1];
fin = init;

for i = 1:length(init)
    if i == 11
        fin(i) = 31;
    else
        fin(i) = init(i)*Q10_list(i)^(1/10);
    end
end

cmap = jet(length(50000:10000:250000));
count=1;
subplot(3,4,9)
for i = 50000:10000:250000
    profile_0 = slow.pt_cell_all{1,1}(:,i);
    t = i/10000-5;
    param=init.*((fin./init).^(1-exp(-t/tc)));
    dotv_v = dotvplot(profile_0,[-65 -58],param,param(end));
    plot(-65:0.1:-58,dotv_v,'Color',cmap(count,:)); hold on
    count = count+1;
end
plot([-65 -58],[0 0],'k')
xlim([-65 -58])

profile_0 = fast.pt_cell_inst{1}(:,50000);
bparam = ones(10,1);
bparam(8) = 1.5;
dotv_v = dotvplot(profile_0,[-65 -58],init,30);
plot(-65:0.1:-58,dotv_v,'Color','k')
hold off

xlabel('Voltage (mV)')
ylabel('dV/dt (V/s)')

colormap('jet')
caxis([0 20])


%% everything cooling vdot

count=1;
subplot(3,4,11)
for i = 50000:10000:250000
    profile_0 = slow.pt_cell_all{2}(:,i);
    t = i/10000-5;
    param=fin.*((init./fin).^(1-exp(-t/tc)));
    dotv_v = dotvplot(profile_0,[-65 -58],param,param(end));
    plot(-65:0.1:-58,dotv_v,'Color',cmap(count,:)); hold on
    count = count+1;
end
plot([-65 -58],[0 0],'k')
xlim([-65 -58])

profile_0 = slow.pt_cell_all{2}(:,50000);
dotv_v = dotvplot(profile_0,[-65 -58],fin,31);
plot(-65:0.1:-58,dotv_v,'Color','k')
hold off

xlabel('Voltage (mV)')
ylabel('dV/dt (V/s)')

colormap('jet')
caxis([0 20])

for i = 5:8
    subplot(3,4,i)
    ylim([0.9 1.2])
end


set(f1,'Units','centimeters')
set(f1,'PaperSize',[18 14])


print('-fillpage','../plots/figure3','-dpdf')
