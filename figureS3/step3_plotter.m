load('../results/one_par_sweep.mat')
addpath('../graphing_functions/')

xt = 0:0.1/1000:120;
ymax = [20,30,60];

figure
for i = 1:12
    if i<10
        subplot(6,2,i)
        profile_t = [pt_cell{i,1}(1,:),pt_cell{i,2}(1,2:end)];
        [~,locs] = findpeaks(profile_t,xt,'MinPeakHeight' ,25);
        plot(locs(1:end-1),1./diff(locs),'k')
        xlim([0 120])
        title(um_init_var(i))
    elseif i == 12
        subplot(6,2,i)
        profile_t = [pt_cell{11,1}(1,:),pt_cell{11,2}(1,2:end)];
        [~,locs] = findpeaks(profile_t,xt,'MinPeakHeight' ,25);
        plot(locs(1:end-1),1./diff(locs),'k')
        xlim([0 120])
        title('Temperature')
    else
        subplot(6,2,i)
        profile_t = [pt_cell{i+2,1}(1,:),pt_cell{i+2,2}(1,2:end)];
        [~,locs] = findpeaks(profile_t,xt,'MinPeakHeight' ,25);
        plot(locs(1:end-1),1./diff(locs),'k')
        xlim([0 120])
        title(um_init_var(i+2))
    end
    
end
    
subplot(6,2,11)
xlabel('Time (s)')
ylabel('Frequency (Hz)')




set(figure(1),'Units','inches')
set(figure(1),'PaperSize',[7 11])
figure(1)
ymin=0; ymax=30;

for i = 1:12
    subplot(6,2,i)
    ylim([ymin ymax])
end
    print('-fillpage','../plots/one_par_plot','-dpdf')
