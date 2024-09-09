clear
close all

linwid = 1.5;
load('fg_Guan_k_step05ppm.mat','offs','zspecExpBatch','MTRasymExpBatch','dataInfo','img_MTR')

%% 1D zspec
Fig = figure(1);
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
set(gca,"YLim",[-0.1,0.4]) 
hold off

legendLabel = dataInfo.experiment.paraArray;
zspeclegend = "k=" + sprintfc('%g',legendLabel)+"Hz";
legend(zspeclegend,'fontsize',6);

set(gca,'fontsize',18);

%% MTR
ind_offs = find(offs==2); % guan
phantom_adjust_MTR = imresize(img_MTR(:,:,ind_offs),[512,512],"nearest");
Fig2 = figure(2);
% mosaic(phantom_adjust_MTR,1,1,2)
% colormap jet
% colorbar
imshow(phantom_adjust_MTR,[])
colormap jet
colorbar

resol = '-r600'; 
imgType = '-dpng';
print(Fig,"Out\fig4F_ex5",imgType,resol);