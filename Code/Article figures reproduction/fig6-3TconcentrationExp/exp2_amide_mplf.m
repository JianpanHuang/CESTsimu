% 20240827
% calculate MPLF and saved to MAT-files

clear 
close all
clc

addpath .\func

%% load data
filelist = ["exp2_amide_40mM_wonoise",...
            "exp2_amide_40mM_wnoise_0.04",...
            "exp2_amide_40mM_wnoise_0.08"];
for idx = 1:length(filelist)
    filename = filelist(idx);
        % img: [nx,ny,nf]
        % img_m0: [nx,ny]
        % offs: [1,nf]
        % roi: [nx,ny]
    
    load(filename);
    
    %% z-spectrum normalization
    img = permute(img,[1,2,4,3]);
    offs = reshape(offs,[],1);
    
    [xn, yn, sn, on] = size(img);
    img_norm = img./repmat((img_m0+eps).*roi, [1,1,1,on]);
    
    %% fit the Z-spectra
    pn = 4; % pool number
    %             1. Water              2. Amide               3. NOE                 4. MT                  
    %      Zi     A1    G1    dw1       A2     G2    dw2       A3     G3    dw3       A4     G4    dw4 
    iv = [ 1      0.9   2.3   0         0.0    2.0   3.5       0.1    4.0   -3.5      0.1    60    -2.5 ];
    lb = [ 1      0.4   1.0   -1.0      0.0    1.0   3.5       0.0    2.0   -3.5      0.001  30    -2.5];
    ub = [ 1      1     6.0   +1.0      0.2    10.0  3.5       0.2    12.5  -3.5      0.3    100   -2.5];
    db0 = zeros(xn, yn, sn);
    apt = zeros(xn, yn, sn);
    apt_inv = zeros(xn, yn, sn, on);
    noe = zeros(xn, yn, sn);
    noe_inv = zeros(xn, yn, sn, on);
    mt = zeros(xn, yn, sn);
    mt_inv = zeros(xn, yn, sn, on);
    guan = zeros(xn, yn, sn);
    guan_inv = zeros(xn, yn, sn, on);
    fit_para = zeros(xn, yn, sn, length(iv));
    roi_vec = roi(:);
    roi_vec(roi_vec==0) = [];
    roi_len = length(roi_vec);
    
    count = 1;
    backNum = 0;
    tic
    for s = 1:sn
        for m = 1:xn
            for n = 1:yn
                if roi(m,n,s) == 1
                    percent = round((count/roi_len)*100,1);
                    fprintf(repmat('\b',1,backNum));
                    backNum =fprintf('Calculation process: %.1f %%',percent);
                    count = count+1;
                    zspec = squeeze(img_norm(m,n,s,:));
                    
                    % fitted arameters
                        %iv: initial value for coeffients X to be fitted
                        %offs: offset frequency as Xdata
                        %zpsec: Z spectrum as Ydata, Ydata = func(X,Xdata)
                        %lb & ub: lower & upper boundary of fitting coeffients X
                    OPTIONS = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective','Display','off');
                    par = lsqcurvefit(@lorentzian4pool,iv,offs,zspec,lb,ub,OPTIONS);
                       
                    db0 = par(4);
                    apt(m,n,s) = par(5);
                    noe(m,n,s) = par(8);
                    mt(m,n,s) = par(11);
                    fit_para(m,n,s,:) = par;
                    
                    % fitted curves
                    cur = zspec_analysis(par, offs, pn);
                    apt_inv(m,n,s,:) = cur(:,4);
                    noe_inv(m,n,s,:) = cur(:,6);
                    mt_inv(m,n,s,:) = cur(:,8);
    
                end
            end
        end   
    end
    fprintf("\nDone\n")
    toc
    
    save(filename+"_mplf.mat",'apt','mt','noe','fit_para','roi','-mat')
    fprintf("mplf fitting results are saved to "+filename+"\n")
end
