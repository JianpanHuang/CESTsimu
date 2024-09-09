% compare 8 cases in BMsim challenge between CESTsimu and pulseq-cest
% two figures, each for 4 cases.
% in each case, plot 3 curves: z-spec (CESTsimu), z-spec (pulseq-cest), diff

% figure parameters can refer to https://www.mathworks.com/help/matlab/ref/matlab.graphics.axis.axes-properties_zh_CN.html#d126e65630

load BMsimchallenge_20240827.mat BMsimchallenge % 8 cases, [offs, zspec(CESTsimu), zspec(pulseq)]

%% output parameters
resol = '-r600'; % resolution greater than 300 dpi
imgType = '-dpng';
linewidth_line = 1.5; % within 0.5-1.5(cm)
axisfontsize = 18;
legendfontsize = 13;
writeflag = 0;

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

%% plot
for caseidx = 1:8
    data = BMsimchallenge{caseidx};
    offs = data(2:end,1); % 1st for -300 ppm
    zspec_pulseq = data(2:end,3)./data(1,3); % normalization: Z/Z_ref
    zspec_CESTsimu = data(2:end,2)./data(1,2);
    zspec_diff = zspec_CESTsimu-zspec_pulseq;

    Fig = figure();
    set(gca,'fontsize',axisfontsize,'XDir','reverse');

    yyaxis left
    colororder(lines(7));
    set(gca,"YColor",'black');
    plot(offs,zspec_pulseq,'LineStyle','-','LineWidth',linewidth_line);hold on
    plot(offs,zspec_CESTsimu,'LineStyle','--','LineWidth',linewidth_line);hold off
    
    xlim([1.1*min(offs(:)),1.1*max(offs(:))]);
    if caseidx <= 4
        ylim([-0.2,1.1]);
    else
        ylim([-1,1.1]);
    end
    xlabel("Offset [ppm]");
    ylabel("Z");

    yyaxis right
    newcolor = lines(3);
    set(gca,"YColor",newcolor(3,:));
    plot(offs,zspec_diff,':','Color',newcolor(3,:),'LineWidth',linewidth_line);
    if caseidx <= 4
        ylim([-0.02,0.02]);
    else
        ylim([-0.04,0.04]);
    end
    ylabel("residual");
    zspec_diff = zspec_pulseq(2:end)./zspec_pulseq(1) - zspec_CESTsimu(2:end)./zspec_CESTsimu(1);
    fprintf("Case"+num2str(caseidx)+": Maximum residual: "+num2str(max(abs(zspec_diff(:))),'%.5f')+"\n")

    if writeflag == 1
        print(Fig,OutputDir+"case"+num2str(caseidx),imgType,resol);

        if caseidx == 1
            % only 1 legend is needed
            legend("Pulseq-CEST","CESTsimu","Difference",'fontsize',legendfontsize,'location','southwest')
            print(Fig,OutputDir+"case"+num2str(caseidx)+"(with legend)",imgType,resol);
        end
    end
end




