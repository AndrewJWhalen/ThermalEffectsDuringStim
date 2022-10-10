load('results/na_l_sweep.mat')
addpath('graphing_functions/')

xt = 0:0.1/1000:5;

figure
for i = 1:4
    subplot(2,2,i)
    plot(xt,pt_cell{i}(1,:))
    title(['Na^+ Q_1_0 = ',num2str(1.4+i*0.2)])
    xlim([0 5])
end
  

set(figure(1),'Units','inches')
set(figure(1),'PaperSize',[4 4])
print('-fillpage','plots/leak_sweep','-dpdf')
