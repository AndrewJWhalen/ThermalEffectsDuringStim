load('results/group_par_sweep.mat')
addpath('graphing_functions/')

%% freq plots
xt = 0:0.1/1000:120;
ymax = [9,9,9,9];
window = 1;
group = {'Gating variable rates','Channel conductances','Leak conductances','Cotransporter strengths'};
factor = [105,110,140];

figure
for i = 1:4 %group
    for ii = 1:3 %level
        g1 = fix((i-1)/2);
        g2 = 2-mod(i,2);
        gi = g1*6+g2+2*(ii-1);
        freq=[];
    
        sp = subplot(6,2,gi);
        profile_t = [group_par_sweeps{i,ii,1}(1,:),group_par_sweeps{i,ii,1}(1,2:end)];
        [~,locs] = findpeaks(profile_t,xt,'MinPeakHeight' ,25);
        for x = 0:0.1:120 
            upper = x+window/2;
            lower = x-window/2;
            if lower>=0 && upper<=xt(end) 
                freq = [freq,[x;sum(locs>=lower & locs<=upper)]];
            end
        end
        plot(freq(1,:),sqrt(freq(2,:)),'k')
        ylim([0 ymax(ii)])
        xlim([0 120])
    
        sp.YTick = 0:3:ymax(ii);
        label = cell(length(sp.YTick),1);
        for iii = 1:length(sp.YTick)
            label{iii} = num2str(sp.YTick(iii)^2);
        end
        sp.YTickLabel = label;
    
        name= [group{i},' ',num2str(factor(ii)),'%'];
        title(name)

    end
end

subplot(6,2,11)
xlabel('Time (s)')
ylabel('Frequency (Hz)')
    


set(figure(1),'Units','inches')
set(figure(1),'PaperSize',[7 9.5])
print('-fillpage','plots/group_sweeps','-dpdf')

