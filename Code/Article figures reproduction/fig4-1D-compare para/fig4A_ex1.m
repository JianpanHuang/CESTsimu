% plot Z-spectra of various B0
linwid = 1.5;

load a_B0_add47T.mat
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
set(gca,'fontsize',18,'XDir', 'reverse');

legend("B0=11.7T","B0=9.4T","B0=7.0T","B0=5.0T","B0=4.7T","B0=3.0T","B0=1.5T",'fontsize',8);


% print(Fig,"fig2A_ex1","-dpng","-r600")
% or can use "save as" after manually adjusting legend position

resol = '-r600'; 
imgType = '-dpng';
print(Fig,"Out\fig4A_ex1",imgType,resol);