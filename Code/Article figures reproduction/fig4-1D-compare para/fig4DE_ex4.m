clear

linwid = 1.5;
load('de_Guan_f_step05ppm.mat','offs','zspecExpBatch','MTRasymExpBatch','dataInfo','img_MTR')

%% 1D zspec
Fig = figure();
hold on;

yyaxis left
xlabel("Offset [ppm]");
ylabel("Z");
set(gca,"YColor",'black');
colororder(jet(9));
for idx = 1:9
    plot(offs(2:end),zspecExpBatch(idx,2:end)/zspecExpBatch(idx,1),'-','LineWidth',linwid);
end

yyaxis right
colororder(jet(9));
for idx = 1:9
    plot(offs(2:end),MTRasymExpBatch(idx,2:end),':','LineWidth',linwid);
end
ylabel("MTR_{asym}")
set(gca,"YLim",[-0.2,0.6],'XDir','reverse') 
hold off

legendLabel = dataInfo.experiment.paraArray;
legendLabel_mM = legendLabel/0.0009009*10;
zspeclegend = "f=" + sprintfc('%.0f',legendLabel_mM) + "mM";
legend(zspeclegend,'fontsize',6);

set(gca,'fontsize',18);

%% MTR
ind_offs = find(offs==2); % guan
phantom_adjust_MTR = imresize(img_MTR(:,:,ind_offs),[512,512],"nearest");
Fig2 = figure();
imshow(phantom_adjust_MTR,[])
colormap jet
colorbar

resol = '-r600'; 
imgType = '-dpng';
print(Fig,"Out\fig4D_ex4",imgType,resol);