% plot Z-spectra of various Tsat
clear
linwid = 1.5;
resol = '-r600'; 
imgType = '-dpng';

load c_Tsat.mat
Fig = figure();
hold on;
colororder(jet(length(zspecHoldonCell)));

for idx = 1:length(zspecHoldonCell)
    temp = zspecHoldonCell{idx};
    offs = temp(:,1);
    zspec = temp(:,2);

    plot(offs(2:end),zspec(2:end)/zspec(1),'LineWidth',linwid);
end
hold off

xlabel("Offset [ppm]");
ylabel("Z");
set(gca,'fontsize',18,'XDir', 'reverse');

legend("Tsat=0.5s","Tsat=1.0s","Tsat=2.0s","Tsat=3.0s",'fontsize',10,'location','southeast');

OutputDir = ".\Out";
% DirTemp = OutputDir;
% cnt = 1;
% while(1)
%     if exist(DirTemp,'dir')
%         DirTemp = OutputDir + "_" + num2str(cnt);
%         cnt = cnt + 1;
%     else
%         break;
%     end
% end
% OutputDir = DirTemp + "\";
% mkdir(OutputDir);
% fprintf("output to folder: "+join( split(OutputDir,'\'),'\\')+"\n");

print(Fig,OutputDir+"fig2C_ex3",imgType,resol);