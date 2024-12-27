% plot Z-spectra of various B1
clear
linwid = 1.5;

load b_B1.mat
Fig = figure();
hold on;
colororder(jet(length(zspecHoldonCell)));

for idx = 1:length(zspecHoldonCell)
    temp = zspecHoldonCell{idx};
    offs = temp(:,1);
    zspec = temp(:,2);

    plot(offs(2:end),zspec(2:end)/zspec(1),'LineWidth',linwid);
end
hold off

xlabel("Offset [ppm]");
ylabel("Z");
set(gca,'fontsize',18,'XDir', 'reverse');

legend("B1=0.8uT","B1=1.6uT","B1=2.4uT","B1=3.0uT","B1=3.7uT",'fontsize',7,'location','southeast');

resol = '-r600'; 
imgType = '-dpng';
print(Fig,"Out\fig2B_ex2",imgType,resol);