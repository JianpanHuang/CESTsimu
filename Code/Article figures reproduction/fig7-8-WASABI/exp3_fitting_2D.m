% Load CESTsim app data, compare WASABI result

% WASABI model
%   Z = abs(1-2*sin(atan((B1/((freq/gamma_)))/(xx-offset))).^2*sin(sqrt((B1/((freq/gamma_))).^2+(xx-offset).^2)*freq*(2*pi)*t_p/2).^2)
% WASABI model (introduce T1/T2 relaxation)
%   Z = abs(c-d*sin(atan((B1/((freq/gamma_)))/(xx-offset))).^2*sin(sqrt((B1/((freq/gamma_))).^2+(xx-offset).^2)*freq*(2*pi)*t_p/2).^2)

%% cut m0 data
filelist = ["20240826-WASABI-2D-T1"];
outputfile_postfix = "_WASABIresult_4var_step001.mat";
for fileidx = 1:1
    load(filelist(fileidx));
    B0map = dataInfo.saturation.B0inhomo_ppm;
    B1map = dataInfo.saturation.B1inhomo_relative;
    img_cest = img;
    %   B0map: [128,128]
    %   B1map: [256,256]
    %   amidef: [1,9]
    %   img_cest: [384,384,81]
    %   img_m0: [384,384], range [0,1]
    %   offs: [1,81], not include m0
    %   pools: [8,1] cells
    mask = roi;
    zmap = img_cest./(img_m0+eps).*mask;
    
    %% generate lookup table
    B1pwr = 3.7; % uT
    B0 = 3; % main field of scanner
    tp = 5; % ms
    
    tp_s = tp*10^-3; % s
    GAMMA = 42.576375; %(Hz/uT) = (MHz/T)
    FREQ = B0 * GAMMA; % scanner frequency in MHz
    
    [WASABI_bib, bib_entries] = lookuptable_WASABI_modified(B1pwr, B0, tp, offs);
    
    cmap_WASABI = zeros(size(img_m0));
    afmap_WASABI = zeros(size(img_m0));
    B0map_WASABI = zeros(size(img_m0));
    B1map_WASABI = zeros(size(img_m0));
    zmap_WASABI = zeros(size(img_cest));
    
    cnt = 1;
    backNum = 0;
    Npixel = length(find(mask~=0));
    tic
    for idx = 1:size(mask,1)
        for idy = 1:size(mask,2)
            if mask(idx,idy) ~= 0
                percent = round((cnt/Npixel)*100,1);
                fprintf(repmat('\b',1,backNum));
                backNum = fprintf('Calculation process: %.1f %%',percent);
                cnt = cnt+1;

                %% minimum search
                zspec = squeeze(zmap(idx,idy,:));
                zspec_diff = WASABI_bib - repmat(reshape(zspec,1,[]),size(WASABI_bib,1),1);
                zspec_diff = sum(abs(zspec_diff),2);

                [~,INDEX] = min(zspec_diff(:));
                BEST_START = bib_entries{INDEX};
                B1 = BEST_START(1);
                db0 = BEST_START(2); % B0 offset
                c = BEST_START(3);
                af = BEST_START(4);

                %% save data
                xx = offs;
                zspec_WASABI = c - af * reshape( sin(atan((B1/((FREQ/GAMMA)))./(xx-db0))).^2,[],1) .* ...
                    reshape(sin(sqrt((B1/((FREQ/GAMMA))).^2+(xx-db0).^2) *FREQ*(2*pi)*tp_s/2).^2,[],1)  ;

                cmap_WASABI(idx,idy) = c;
                afmap_WASABI(idx,idy) = af;
                B0map_WASABI(idx,idy) = db0;
                B1map_WASABI(idx,idy) = B1;
                zmap_WASABI(idx,idy,:) = zspec_WASABI;

                % figure();
                % plot(offs,zspec,'ro',offs,zspec_WASABI,'b-');
                % xlabel('\Delta \omega [ppm]'); ylabel('Z (\Delta\omega)');
                % title("db0 = " + num2str(db0,3) + " ppm, rB1 = " + num2str(B1/B1pwr,2))
                % legend('measured','WASABI')
            end
        end
    end
    fprintf(repmat('\b',1,backNum));
    fprintf("Calculation done!\n");
    toc
    save(filelist(fileidx)+outputfile_postfix,'B0map','B0map_WASABI','B1map','B1map_WASABI','zmap','zmap_WASABI','cmap_WASABI','afmap_WASABI','-mat');
end