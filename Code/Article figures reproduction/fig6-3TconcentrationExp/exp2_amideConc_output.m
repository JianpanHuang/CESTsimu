% display MPLF results and output
% 2024-0701
clear
close all

resol = '-r600'; 
imgType = '-dpng';
linwid = 1.5;
fonts_axis = 10;
fonts_leg = 8;
markersiz = 2;
writeflag = 1;

fraction = 0:5:40; % mM
zupbound = 0.07;
Xbound = [-5,45];
Ybound = [-0.0035,0.067];
Xupbound = 45;
patchcol = "#f06464";

%% load files 
filelist = ["exp2_amide_40mM_wonoise_mplf",...
            "exp2_amide_40mM_wnoise_0.0016_mplf",...
            "exp2_amide_40mM_wnoise_0.0064_mplf"];
load(filelist(1),'apt','roi'); apt_1 = apt;
load(filelist(2),'apt'); apt_2 = apt;
load(filelist(3),'apt'); apt_3 = apt;
%   roi: region of interest, [nx,ny]
%   apt: fraction of amide, [nx,ny]
%   mt: fraction of mt, [nx,ny]
%   noe: fraction of amide, [nx,ny]


%% plot Z map of amide
colormapLegend = "jet";

Fig1 = figure(1);imshow(apt_1,[])
colormap(colormapLegend)
colorbar
clim([0,zupbound])
title("amide \sigma=0")
set(gca,'Position',[0.1,0.1,0.7,0.8],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[100 600 300 300]);

Fig2 = figure(2);imshow(apt_2,[])
colormap(colormapLegend)
colorbar
clim([0,zupbound])
title("amide \sigma=0.0016")
set(gca,'Position',[0.1,0.1,0.7,0.8],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[400 600 300 300]);

Fig3 = figure(3);imshow(apt_3,[])
colormap(colormapLegend)
colorbar
clim([0,zupbound])
title("amide \sigma=0.0064")
set(gca,'Position',[0.1,0.1,0.7,0.8],'fontname','arial','fontsize',fonts_axis,'FontName','Times New Roman');
set(gcf,'Position',[700 600 300 300]);

%% plot scatter in roi
Np = 128; % size of subimage
roisub = roi(1:Np,1:Np);
[idxroisub,idyroisub] = find(roisub==1);

XData = zeros(length(idxroisub),9);
YData_1 = zeros(length(idxroisub),9);
YData_2 = zeros(length(idxroisub),9);
YData_3 = zeros(length(idxroisub),9);

idxroi = zeros(length(idxroisub),9);
idyroi = zeros(length(idxroisub),9);
idxmulti = [0,0,0,1,1,1,2,2,2];
idymulti = [0,1,2,0,1,2,0,1,2];
for id = 1:9
    XData(:,id) = fraction(id) * ones(length(idxroisub),1);
    roiidx = sub2ind([Np*3,Np*3],idxroisub + Np*idxmulti(id),idyroisub + Np*idymulti(id));
    YData_1(:,id) = apt_1( roiidx );
    YData_2(:,id) = apt_2( roiidx );
    YData_3(:,id) = apt_3( roiidx );
end

% sigma = 0
Fig4 = figure(4);hold on
[fitresult,gof] = fit(XData(:),YData_1(:),'poly1');
fprintf("sigma=0.0000: [SSE, R2] = [%.4f,%.4f]\n",gof.sse,gof.rsquare)
pred = predint(fitresult,XData(:),0.95,'observation','on');

plot(XData(:),YData_1(:),'h','Color',[0,0.45,0.74],'MarkerSize',markersiz,'LineWidth',linwid-0.5)
plot(XData(:),fitresult.p1*XData(:)+fitresult.p2,'LineWidth',linwid,'Color','r');
plot(XData(:),pred,'--','LineWidth',linwid,'Color',patchcol);
pa = patch([fraction(1),fraction(end),fraction(end),fraction(1)],[pred(1,1),pred(end,1),pred(end,2),pred(1,2)],'r');
pa.FaceColor = patchcol;pa.LineStyle = 'none';pa.FaceAlpha = 0.2;
hold off

legend({'Data','Fitted curve', 'CB (95%)'},...
       'FontSize',8,'Location','northwest','FontSize',fonts_leg)
xlabel('concentration [mM]');ylabel('concentration (MPLF)')
xlim(Xbound);ylim(Ybound);box on
set(gca,'FontName','arial','FontSize',fonts_axis,'LineWidth',1)
set(gcf,'Position',[100 300 300 250]);

% sigma = 0.04
Fig5 = figure(5);hold on
[fitresult,gof] = fit(XData(:),YData_2(:),'poly1');
fprintf("sigma=0.0016: [SSE, R2] = [%.4f,%.4f]\n",gof.sse,gof.rsquare)
pred = predint(fitresult,XData(:),0.95,'observation','on');

plot(XData(:),YData_2(:),'h','Color',[0,0.45,0.74],'MarkerSize',markersiz,'LineWidth',linwid-0.5)
plot(XData(:),fitresult.p1*XData(:)+fitresult.p2,'LineWidth',linwid,'Color','r');
plot(XData(:),pred,'--','LineWidth',linwid,'Color',patchcol);
pa = patch([fraction(1),fraction(end),fraction(end),fraction(1)],[pred(1,1),pred(end,1),pred(end,2),pred(1,2)],'r');
pa.FaceColor = patchcol;pa.LineStyle = 'none';pa.FaceAlpha = 0.2;
hold off

legend({'Data','Fitted curve', 'CB (95%)'},...
       'FontSize',8,'Location','northwest','FontSize',fonts_leg)
xlabel('concentration [mM]');ylabel('concentration (MPLF)')
xlim(Xbound);ylim(Ybound);box on
set(gca,'FontName','arial','FontSize',fonts_axis,'LineWidth',1)
set(gcf,'Position',[400 300 300 250]);

% sigma = 0.08
Fig6 = figure(6);hold on
[fitresult,gof] = fit(XData(:),YData_3(:),'poly1');
fprintf("sigma=0.0064: [SSE, R2] = [%.4f,%.4f]\n",gof.sse,gof.rsquare)
pred = predint(fitresult,XData(:),0.95,'observation','on');

plot(XData(:),YData_3(:),'h','Color',[0,0.45,0.74],'MarkerSize',markersiz,'LineWidth',linwid-0.5)
plot(XData(:),fitresult.p1*XData(:)+fitresult.p2,'LineWidth',linwid,'Color','r');
plot(XData(:),pred,'--','LineWidth',linwid,'Color',patchcol);
pa = patch([fraction(1),fraction(end),fraction(end),fraction(1)],[pred(1,1),pred(end,1),pred(end,2),pred(1,2)],'r');
pa.FaceColor = patchcol;pa.LineStyle = 'none';pa.FaceAlpha = 0.2;
hold off

legend({'Data','Fitted curve', 'CB (95%)'},...
       'FontSize',8,'Location','northwest','FontSize',fonts_leg)
xlabel('concentration [mM]');ylabel('concentration (MPLF)')
xlim(Xbound);ylim(Ybound);box on
set(gca,'FontName','arial','FontSize',fonts_axis,'LineWidth',1)
set(gcf,'Position',[700 300 300 250]);

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

    print(Fig1,OutputDir+"figure_1",imgType,resol);
    print(Fig2,OutputDir+"figure_2",imgType,resol);
    print(Fig3,OutputDir+"figure_3",imgType,resol);
    print(Fig4,OutputDir+"figure_4",imgType,resol);
    print(Fig5,OutputDir+"figure_5",imgType,resol);
    print(Fig6,OutputDir+"figure_6",imgType,resol);
end
