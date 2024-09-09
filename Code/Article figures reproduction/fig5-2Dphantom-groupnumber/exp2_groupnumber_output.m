% display CEST images and MTRasym and output
% 2024-0801
clear
close all

resol = '-r600'; 
imgType = '-dpng';
writeflag = 1;

colormapLegend = "parula";

%% create empty output folder
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
    fprintf("images will be exported to "+join( split(OutputDir,'\'),'\\')+"\n");
end

%% save figure
filelist = ["exp2_amide_40mM_group5",...
            "exp2_amide_40mM_group9",...
            "exp2_amide_40mM_group13"];
idx_amide = 10; % 3.5 ppm
for i = 1:3
    load(filelist(i),'roi','img','img_m0','img_MTR'); 
    CESTimg = imresize(img(:,:,idx_amide)./(img_m0+eps).*roi,[512,512],"nearest");
    MTRimg = imresize(img_MTR(:,:,idx_amide),[512,512],"nearest");

    Fig1 = figure();imshow(CESTimg,[]);colormap('gray');clim([0.6,0.8])
    Fig2 = figure();imshow(MTRimg,[]);colormap(colormapLegend);

    if writeflag == 1
        print(Fig1,OutputDir+"CEST_"+num2str(i),imgType,resol);
        print(Fig2,OutputDir+"MTR_"+num2str(i),imgType,resol);

        if i == 1
            Fig3 = figure();imshow(CESTimg,[]);colormap('gray');clim([0.6,0.8]);colorbar
            print(Fig3,OutputDir+"CEST_legend_"+num2str(i),imgType,resol);

            Fig4 = figure();imshow(MTRimg,[]);colormap(colormapLegend);colorbar
            print(Fig4,OutputDir+"MTR_legend_"+num2str(i),imgType,resol);
        end
    end
    
end