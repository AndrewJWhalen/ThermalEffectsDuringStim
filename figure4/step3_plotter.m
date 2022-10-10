load('results/tc_variation.mat')
addpath('graphing_functions/')

fig=figure;
c = 'rgbm';
start=5000;
finish = [100000,950000,350000,2500000];
dsn = [10,10,10,10];
subplot(1,2,1)
for i = 1:4
    profile_t = concentration(downsample(pt_cell{i,1}.',dsn(i)).');

    finish_ds = floor(finish(i)/dsn(i))+1;
    start_ds = floor(start/dsn(i))+1;
    y=profile_t(6,start_ds:finish_ds);
    x=profile_t(9,start_ds:finish_ds);
    z = profile_t(12,start_ds:finish_ds);
    plot3(x,y,z,'Color',c(i))
    hold on
end
grid on
hold off

subplot(1,2,2)
for i = 1:4
    profile_t = concentration(downsample(pt_cell{i,2}.',dsn(i)).');

    finish_ds = floor(finish(i)/dsn(i))+1;
    start_ds = floor(start/dsn(i))+1;
    y=profile_t(6,start_ds:finish_ds);
    x=profile_t(9,start_ds:finish_ds);
    z = profile_t(12,start_ds:finish_ds);
    plot3(x,y,z,'Color',c(i))
    hold on
end
grid on
hold off


for i=1:2
    subplot(1,2,i)
    ylabel('K_o (mM)')
    xlabel('Na_i (mM)')
    zlabel('O_2 (mg/L)')
end
legend('0 s', '5 s','50 s','500 s')
set(fig,'PaperUnits','centimeters')
set(fig,'PaperSize',[20 10])

print('-fillpage','../plots/trajectory','-dpdf','-r600')
