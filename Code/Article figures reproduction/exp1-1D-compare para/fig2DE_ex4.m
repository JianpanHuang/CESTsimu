clear

linwid = 1.5;
load('de_Guan_f.mat','offs','zspecExpBatch','MTRasymExpBatch','dataInfo','img_MTR','zspecBatch_m0')

%% 1D zspec
Fig = figure();
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

legendLabel = dataInfo.experiment.poolsArr{5}.Guan; % [T1,T2,k,w,f]
legendLabel_mM = legendLabel*1000;
zspeclegend = "f=" + sprintfc('%.1f',legendLabel_mM) + "mM";
legend(zspeclegend,'fontsize',6);

set(gca,'fontsize',18);

%% MTR
ind_offs = find(offs==2); % guan
phantom_adjust_MTR = imresize(img_MTR(:,:,ind_offs),[512,512],"nearest");
phantom_adjust_MTR(phantom_adjust_MTR==0) = -100;
Fig2 = figure();
imshow(phantom_adjust_MTR,[])
colormap jet
colorbar
clim([-0.02,0.02])

resol = '-r600'; 
imgType = '-dpng';
% print(Fig,"Out\fig2D_ex4",imgType,resol);