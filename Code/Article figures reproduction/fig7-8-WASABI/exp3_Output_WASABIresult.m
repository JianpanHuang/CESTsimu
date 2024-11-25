% display WASABI result and real B0 map
close all
clear

filename = "WASABI_result";
resol = '-r600'; 
imgType = '-dpng';
linwid = 1.5;
fonts_axis = 10;
markersiz = 5;
writeflag = 1;

%% B1/B0 map result
B1value = 3.7; %uT

load(filename);
B0map_OriWASABI = B0map_WASABI;
B1map_OriWASABI = B1map_WASABI/B1value;

B0map = imresize(B0map,size(B0map_OriWASABI),"nearest");
B1map = imresize(B1map,size(B1map_OriWASABI),"nearest");
roi = B1map_OriWASABI~=0;

colormapLegend = "jet";

F1 = figure(1);imshow(B0map.*roi,[]);
colormap(colormapLegend)
colorbar
clim([min(B0map.*roi,[],'all'),max(B0map.*roi,[],'all')])
title("dB_0 map (simulated)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 700 300 250]);

F2 = figure(2);imshow(-B0map_OriWASABI,[])
colormap(colormapLegend)
colorbar
clim([min(B0map.*roi,[],'all'),max(B0map.*roi,[],'all')])
title("dB_0 map (WASABI)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[400 700 300 250]);

F3 = figure(3);imshow(B1map.*roi,[]);
colormap(colormapLegend)
colorbar
clim([min(B1map(roi~=0),[],'all'),max(B1map.*roi,[],'all')])
title("rB_1 map (simulated)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 300 300 250]);

F4 = figure(4);imshow(B1map_OriWASABI,[])
colormap(colormapLegend)
colorbar
clim([min(B1map(roi~=0),[],'all'),max(B1map.*roi,[],'all')])
title("rB_1 map (WASABI)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[400 300 300 250]);

%% Bland-Altman plot of B0
% close all
Yupbound = 0.04;
Ylowbound = -0.02;
Xupbound = 0.7;
Xlowbound = 0;

data_B0 = reshape(B0map(roi~=0),[],1);
data_B0_WASABI_Ori = reshape(B0map_OriWASABI(roi~=0),[],1);

% WASABI
X_Ori = (data_B0 - data_B0_WASABI_Ori)/2;
Y_Ori = (data_B0 + data_B0_WASABI_Ori);
mean_Ori = mean(Y_Ori);
std_Ori = sqrt( sum( (Y_Ori-mean_Ori).^2,"all" )/length(Y_Ori) );
fprintf("B0 (WASABI): [1.96 SD, MEAN, -1.96 SD]=[%.4f,%.4f,%.4f]\n",mean_Ori-1.96*std_Ori,mean_Ori,mean_Ori+1.96*std_Ori);

F5 = figure(5);
hold on
plot(X_Ori,Y_Ori,'.','Color',[0.4275,0.7882,0.5961],'MarkerSize',markersiz)

xlabel('Avg. of Simulated and WASABI B0 Value [ppm]');
ylabel('Error in Prediction [ppm]');
title('BA for B0 (WASABI)')

plot([Xlowbound,Xupbound],[mean_Ori+1.96*std_Ori,mean_Ori+1.96*std_Ori],'r:','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_Ori,mean_Ori],'r-','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_Ori-1.96*std_Ori,mean_Ori-1.96*std_Ori],'r:','LineWidth',linwid);
hold off

box on
xlim([Xlowbound,Xupbound]);
ylim([Ylowbound,Yupbound]);
set(gca,'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[700 700 350 250]);

%% Bland-Altman plot of B1
% close all
Yupbound = 0.03;
Ylowbound = -0.025;
Xupbound = 1.4;
Xlowbound = 0.8;

data_B1 = reshape(B1map(roi~=0),[],1);
data_B1_WASABI_Fas = reshape(B1map_OriWASABI(roi~=0),[],1);
data_B1_WASABI_Ori = reshape(B1map_OriWASABI(roi~=0),[],1);


% WASABI
X_Ori = (data_B1 + data_B1_WASABI_Ori)/2;
Y_Ori = (data_B1 - data_B1_WASABI_Ori);
mean_Ori = mean(Y_Ori);
std_Ori = sqrt( sum( (Y_Ori-mean_Ori).^2,"all" )/length(Y_Ori) );
fprintf("B1 (WASABI): [1.96 SD, MEAN, -1.96 SD]=[%.4f,%.4f,%.4f]\n",mean_Ori-1.96*std_Ori,mean_Ori,mean_Ori+1.96*std_Ori);

F6 = figure(6);
hold on
plot(X_Ori,Y_Ori,'.','Color',[0.4275,0.7882,0.5961],'MarkerSize',markersiz)

xlabel('Avg. of Simulated and WASABI B1 Value [a.u.]');
ylabel('Error in Prediction [a.u.]');
title('BA for B1 (WASABI)')

plot([Xlowbound,Xupbound],[mean_Ori+1.96*std_Ori,mean_Ori+1.96*std_Ori],'r:','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_Ori,mean_Ori],'r-','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_Ori-1.96*std_Ori,mean_Ori-1.96*std_Ori],'r:','LineWidth',linwid);
hold off

box on
xlim([Xlowbound,Xupbound]);
ylim([Ylowbound,Yupbound]);
set(gca,'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[700 300 350 250]);

%% create empty folder and print
if writeflag == 1
    OutputDir = ".\Out";
    DirTemp = OutputDir;
    cnt = 1;
    while(1)
        if exist(DirTemp,'dir')
            DirTemp = OutputDir + "_" + num2str(cnt);
            cnt = cnt + 1;
        else
            break;
        end
    end
    OutputDir = DirTemp + "\";
    mkdir(OutputDir);
    fprintf("output to folder: "+join( split(OutputDir,'\'),'\\')+"\n");

    print(F1,OutputDir+"figure_1",imgType,resol);
    print(F2,OutputDir+"figure_2",imgType,resol);
    print(F3,OutputDir+"figure_3",imgType,resol);
    print(F4,OutputDir+"figure_4",imgType,resol);
    print(F5,OutputDir+"figure_5",imgType,resol);
    print(F6,OutputDir+"figure_6",imgType,resol);
end
