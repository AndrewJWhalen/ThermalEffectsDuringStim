load('../results/instant_pump.mat')
profile_0 = p_list{1}(:,5*10000);
xnstep = 10;
ynstep = 10;


for point = [1,3]
    
    subplot(3,2,1+fix(point/2))
    fieldmap_m_vsolve
    subplot(3,2,3+fix(point/2))
    fieldmap_h_vsolve
    subplot(3,2,5+fix(point/2))
    fieldmap_n_vsolve

end

set(figure(1),'Units','inches')
set(figure(1),'PaperSize',[6 8])
print(figure(1),'-fillpage','../plots/mhn_fieldmaps','-dpdf')