% display WASABI result and real B0 map
close all
clear

filelist = ["20240826-WASABI-2D-T1_WASABIresult_2var_step001",...
            "20240826-WASABI-2D-T1_WASABIresult_4var_step001"];
resol = '-r600'; 
imgType = '-dpng';
linwid = 1.5;
fonts_axis = 10;
markersiz = 5;
writeflag = 0;


%% B1/B0 map result
B1value = 3.7; %uT

fileidx = 1;load(filelist(fileidx));
B0map_WASABI_2var = B0map_WASABI;
B1map_WASABI_2var = B1map_WASABI/B1value;

fileidx = 2;load(filelist(fileidx));
B0map_WASABI_4var = B0map_WASABI;
B1map_WASABI_4var = B1map_WASABI/B1value;

B0map = imresize(B0map,size(B0map_WASABI_4var),"nearest");
B1map = imresize(B1map,size(B1map_WASABI_4var),"nearest");
roi = B1map_WASABI_4var~=0;



colormapLegend = "jet";

F1 = figure(1);imshow(B0map.*roi,[]);
colormap(colormapLegend)
colorbar
clim([0,max(B0map.*roi,[],'all')])
title("dB_0 map (simulated)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 700 300 250]);

F2 = figure(2);imshow(-B0map_WASABI_2var,[])
colormap(colormapLegend)
colorbar
clim([0,max(B0map.*roi,[],'all')])
title("dB_0 map (WASABI\_2var)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[400 700 300 250]);

F3 = figure(3);imshow(-B0map_WASABI_4var,[])
colormap(colormapLegend)
colorbar
clim([0,max(B0map.*roi,[],'all')])
title("dB_0 map (WASABI\_4var)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[700 700 300 250]);


F4 = figure(4);imshow(B1map.*roi,[]);
colormap(colormapLegend)
colorbar
clim([min(B1map_WASABI_2var(roi~=0),[],'all'),max(B1map_WASABI_2var.*roi,[],'all')])
title("rB_1 map (simulated)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 300 300 250]);

F5 = figure(5);imshow(B1map_WASABI_2var,[])
colormap(colormapLegend)
colorbar
clim([min(B1map_WASABI_2var(roi~=0),[],'all'),max(B1map_WASABI_2var.*roi,[],'all')])
title("rB_1 map (WASABI\_2var)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[400 300 300 250]);

F6 = figure(6);imshow(B1map_WASABI_4var,[])
colormap(colormapLegend)
colorbar
clim([min(B1map_WASABI_2var(roi~=0),[],'all'),max(B1map_WASABI_2var.*roi,[],'all')])
title("rB_1 map (WASABI\_4var)")
set(gca,'Position',[0.1,0.1,0.7,0.7],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[700 300 300 250]);

%% Bland-Altman plot of B0
% close all
Yupbound = 0.15;
Ylowbound = -0.05;
Xupbound = 0.7;
Xlowbound = 0;

data_B0 = reshape(B0map(roi~=0),[],1);
data_B0_WASABI_2var = reshape(B0map_WASABI_2var(roi~=0),[],1);
data_B0_WASABI_4var = reshape(B0map_WASABI_4var(roi~=0),[],1);

% (1) 2 var
X_2var = (data_B0 - data_B0_WASABI_2var)/2;
Y_2var = (data_B0 + data_B0_WASABI_2var);
mean_2var = mean(Y_2var);
std_2var = sqrt( sum( (Y_2var-mean_2var).^2,"all" )/length(Y_2var) );
fprintf("B0 (2var): [1.96 SD, MEAN, -1.96 SD]=[%.4f,%.4f,%.4f]\n",mean_2var-1.96*std_2var,mean_2var,mean_2var+1.96*std_2var);

F7 = figure(7);
hold on
plot(X_2var,Y_2var,'.','Color',[0,0.45,0.74],'MarkerSize',markersiz)

xlabel('Avg. of Simulated and WASABI B0 Value (ppm)','FontSize',fonts_axis,'FontName','Times New Roman');
ylabel('Error in Prediction (ppm)','FontSize',fonts_axis,'fontweight','bold','FontName','Times New Roman');
title('BA for 2var B0')

plot([Xlowbound,Xupbound],[mean_2var+1.96*std_2var,mean_2var+1.96*std_2var],'r:','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_2var,mean_2var],'r-','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_2var-1.96*std_2var,mean_2var-1.96*std_2var],'r:','LineWidth',linwid);
hold off

box on
xlim([Xlowbound,Xupbound]);
ylim([Ylowbound,Yupbound]);
set(gca,'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 500 350 250]);

% (2) 4 var
X_4var = (data_B0 - data_B0_WASABI_4var)/2;
Y_4var = (data_B0 + data_B0_WASABI_4var);
mean_4var = mean(Y_4var);
std_4var = sqrt( sum( (Y_4var-mean_4var).^2,"all" )/length(Y_4var) );
fprintf("B0 (4var): [1.96 SD, MEAN, -1.96 SD]=[%.4f,%.4f,%.4f]\n",mean_4var-1.96*std_4var,mean_4var,mean_4var+1.96*std_4var);

F8 = figure(8);
hold on
plot(X_4var,Y_4var,'.','Color',[0.4275,0.7882,0.5961],'MarkerSize',markersiz)

xlabel('Avg. of Simulated and WASABI B0 Value (ppm)');
ylabel('Error in Prediction (ppm)');
title('BA for 4var B0')

plot([Xlowbound,Xupbound],[mean_4var+1.96*std_4var,mean_4var+1.96*std_4var],'r:','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_4var,mean_4var],'r-','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_4var-1.96*std_4var,mean_4var-1.96*std_4var],'r:','LineWidth',linwid);
hold off

box on
xlim([Xlowbound,Xupbound]);
ylim([Ylowbound,Yupbound]);
set(gca,'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[550 500 350 250]);

%% Bland-Altman plot of B1
% close all
Yupbound = 0.1;
Ylowbound = -0.1;
Xupbound = 1.23;
Xlowbound = 0.8;

data_B1 = reshape(B1map(roi~=0),[],1);
data_B1_WASABI_2var = reshape(B1map_WASABI_2var(roi~=0),[],1);
data_B1_WASABI_4var = reshape(B1map_WASABI_4var(roi~=0),[],1);

% (1) 2 var
X_2var = (data_B1 + data_B1_WASABI_2var)/2;
Y_2var = (data_B1 - data_B1_WASABI_2var);
mean_2var = mean(Y_2var);
std_2var = sqrt( sum( (Y_2var-mean_2var).^2,"all" )/length(Y_2var) );
fprintf("B1 (2var): [1.96 SD, MEAN, -1.96 SD]=[%.4f,%.4f,%.4f]\n",mean_2var-1.96*std_2var,mean_2var,mean_2var+1.96*std_2var);

F9 = figure(9);
hold on
plot(X_2var,Y_2var,'.','Color',[0,0.45,0.74],'MarkerSize',markersiz)

xlabel('Avg. of Simulated and WASABI B1 Value (a.u.)','FontSize',fonts_axis,'fontweight','bold','FontName','Times New Roman');
ylabel('Error in Prediction (a.u.)','FontSize',fonts_axis,'fontweight','bold','FontName','Times New Roman');
title('BA for 2var B1')

plot([Xlowbound,Xupbound],[mean_2var+1.96*std_2var,mean_2var+1.96*std_2var],'r:','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_2var,mean_2var],'r-','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_2var-1.96*std_2var,mean_2var-1.96*std_2var],'r:','LineWidth',linwid);
hold off

box on
xlim([Xlowbound,Xupbound]);
ylim([Ylowbound,Yupbound]);
set(gca,'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 100 350 250]);


% (2) 4 var
X_4var = (data_B1 + data_B1_WASABI_4var)/2;
Y_4var = (data_B1 - data_B1_WASABI_4var);
mean_4var = mean(Y_4var);
std_4var = sqrt( sum( (Y_4var-mean_4var).^2,"all" )/length(Y_4var) );
fprintf("B1 (4var): [1.96 SD, MEAN, -1.96 SD]=[%.4f,%.4f,%.4f]\n",mean_4var-1.96*std_4var,mean_4var,mean_4var+1.96*std_4var);

F10 = figure(10);
hold on
plot(X_4var,Y_4var,'.','Color',[0.4275,0.7882,0.5961],'MarkerSize',markersiz)

xlabel('Avg. of Simulated and WASABI B1 Value (a.u.)');
ylabel('Error in Prediction (a.u.)');
title('BA for 4var B1')

plot([Xlowbound,Xupbound],[mean_4var+1.96*std_4var,mean_4var+1.96*std_4var],'r:','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_4var,mean_4var],'r-','LineWidth',linwid);
plot([Xlowbound,Xupbound],[mean_4var-1.96*std_4var,mean_4var-1.96*std_4var],'r:','LineWidth',linwid);
hold off

box on
xlim([Xlowbound,Xupbound]);
ylim([Ylowbound,Yupbound]);
set(gca,'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[550 100 350 250]);

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
    print(F7,OutputDir+"figure_7",imgType,resol);
    print(F8,OutputDir+"figure_8",imgType,resol);
    print(F9,OutputDir+"figure_9",imgType,resol);
    print(F10,OutputDir+"figure_10",imgType,resol);
end
