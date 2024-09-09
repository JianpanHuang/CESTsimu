function [WASABI_bib, bib_entries] = lookuptable_WASABI_modified(B1pwr, B0, tp, offs)
% Input:
%   tp: pulse duration in ms (default is 5 ms)
%   B1: saturation power in uT, default is 3.7 uT
%   B0: main field of scanner in T
%   offs: frequency offset (of RF) list in ppm, (default is -2:0.05:2)
% Output:
%   WASABI_bib: [nB1*ndb0*nc*na,noffs]
%   bib_entries: [nB1*ndb0*nc*na,1]

    tic
    % predefine parameter
    % B1pwr = 3.7; % uT
    % B0 = 3; % main field of scanner
    % tp = 5; % ms
    tp_s = tp*10^-3; % s
    GAMMA = 42.576375; %(Hz/uT) = (MHz/T)
    FREQ = B0 * GAMMA; % scanner frequency in MHz
    
    
    % define 4 variables in WASABI model:
    B1_bib=(0.8:0.01:1.2)*B1pwr; % B1 value
    offset_bib=(-0.5:0.01:0.5); % water frequency offset (B0 inhomogenity), ppm
    % c_bib=1; % accounting for T1/T2 relaxation
    % af_bib=2; % accounting for T1/T2 relaxation
    c_bib=(0.2:0.1:1); % accounting for T1/T2 relaxation
    af_bib=(0.5:0.1:2.0); % accounting for T1/T2 relaxation
    
    % create lookup table
    tablesize = length(B1_bib)*length(offset_bib)*length(c_bib)*length(af_bib);
    WASABI_bib = zeros(tablesize,length(offs));
    cnt = 1;
    for ii=1:numel(B1_bib)
        for jj=1:numel(offset_bib)
            for kk=1:numel(c_bib)
                for ll=1:numel(af_bib)
                    for mm=1:numel(offs)
                        B1=B1_bib(ii);
                        offset=offset_bib(jj);
                        c=c_bib(kk);
                        af=af_bib(ll);
                        xx=offs(mm);
    
                        WASABI_bib(cnt,mm)=c-af*sin(atan((B1/((FREQ/GAMMA)))/(xx-offset))).^2*sin(sqrt((B1/((FREQ/GAMMA))).^2+(xx-offset).^2) *FREQ*(2*pi)*tp_s/2).^2;
                    end
                    bib_entries{cnt} = [B1 offset c af];
                    cnt = cnt + 1;
                end
            end
        end
    end
    toc
    fprintf("lookup table successfully generated\n")
end