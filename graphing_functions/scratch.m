
xt = 0.0001:0.0001:180;

for i = 1:6
    figure('units','normalized','outerposition',[0 0 1 1])

    subplot(5,1,1)
    plot(xt,p_list_c{i}(1,1:end-1))
    title('V')
    ylim([-64 -60])

    subplot(5,1,2)
    plot(xt,c_list{i}(1,:)/c_list{i}(1,1))
    title('Pump')
    ylim([0.5 1.05])
    
    subplot(5,1,3)
    plot(xt,c_list{i}(7,:)/c_list{i}(7,1))
    title('O2 multiplier')
    ylim([0.5 1.05])
    
    subplot(5,1,4)
    plot(xt,c_list{i}(8,:)/c_list{i}(8,1))
    title('Na multiplier')
    ylim([0.5 1.05])
    
    subplot(5,1,5)
    plot(xt,c_list{i}(9,:)/c_list{i}(9,1))
    ylim([0.5 1.05])
    title('K multiplier')
end

%%

start=1580;
fin = 1700;

figure
subplot(4,1,1)
plot(p_list_c{i}(1,start:fin))
title('V')

subplot(4,1,2)
plot(p_list_c{i}(2,start:fin).^3)
title('m3')

subplot(4,1,3)
plot(p_list_c{i}(3,start:fin))
title('h')

subplot(4,1,4)
plot(p_list_c{i}(4,start:fin).^4)
title('n4')

%% endpiece calculation
p_list_c_2 = cell(6,1);
for i = 1:6
    p_list_c_2{i} = concentration(p_list{i,2});
end

figure
for i = 1:6
    subplot(3,2,i)
    plot(p_list_c_2{2}(i+5,:))
    title(title_list(i))
end

figure
plot(p_list_c_2{2}(1,:))


%%save multiple figures

for i = 1:10
    rt = ['/storage/home/tuk158/scratch/',num2str(i),'.png'];
    saveas(figure(i),rt)
end

