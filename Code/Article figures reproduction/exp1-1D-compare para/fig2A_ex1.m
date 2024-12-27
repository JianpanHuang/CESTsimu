% plot Z-spectra of various Trec (recovery time, gap before saturation)
linwid = 1.5;

load a_Trec.mat
Fig = figure();
hold on;
colororder(jet(length(zspecHoldonCell)));

for idx = length(zspecHoldonCell):-1:1
    temp = zspecHoldonCell{idx};
    offs = temp(:,1);
    zspec = temp(:,2);

    plot(offs(2:end),zspec(2:end)/zspec(1),'LineWidth',linwid);
end
hold off

xlabel("Offset [ppm]");
ylabel("Z");
ylim([0.65,0.85])
xlim([2,8])
set(gca,'fontsize',18,'XDir', 'reverse');

legend("Trec=Inf","Trec=2.0s","Trec=1.5s","Trec=1.0s","Trec=0.5s","Trec=0.2s","Trec=0.0s",'fontsize',9);


% print(Fig,"fig2A_ex1","-dpng","-r600")
% or can use "save as" after manually adjusting legend position

resol = '-r600'; 
imgType = '-dpng';
print(Fig,"Out\fig2A_ex1",imgType,resol);