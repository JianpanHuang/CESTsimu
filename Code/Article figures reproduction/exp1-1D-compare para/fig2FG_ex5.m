clear
close all

linwid = 1.5;
load('fg_Guan_k.mat','offs','zspecExpBatch','MTRasymExpBatch','dataInfo','img_MTR','zspecBatch_m0')

%% 1D zspec
Fig = figure(1);
hold on;

yyaxis left
xlabel("Offset [ppm]");
ylabel("Z");
set(gca,"YColor",'black');
colororder(jet(9));
for idx = 1:9
    plot(offs,zspecExpBatch(idx,:)/zspecBatch_m0(idx),'-','LineWidth',linwid);
end

yyaxis right
colororder(jet(9));
for idx = 1:9
    plot(offs,MTRasymExpBatch(idx,:),':','LineWidth',linwid);
end
ylabel("MTR_{asym}")
set(gca,"YLim",[-0.1,0.2],'XDir','reverse') 
hold off

legendLabel = dataInfo.experiment.poolsArr{3}.Guan; % [T1,T2,k,w,f]
zspeclegend = "k=" + sprintfc('%g',legendLabel)+"Hz";
legend(zspeclegend,'fontsize',6);

set(gca,'fontsize',18);

%% MTR
ind_offs = find(offs==2); % guan
phantom_adjust_MTR = imresize(img_MTR(:,:,ind_offs),[512,512],"nearest");
phantom_adjust_MTR(phantom_adjust_MTR==0) = -100;
Fig2 = figure(2);
% mosaic(phantom_adjust_MTR,1,1,2)
% colormap jet
% colorbar
imshow(phantom_adjust_MTR,[])
colormap jet
colorbar
clim([-0.01,0.025])

resol = '-r600'; 
imgType = '-dpng';
% print(Fig,"Out\fig2F_ex5",imgType,resol);