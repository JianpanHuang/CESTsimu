%{
Nonlinear fitting using lookup-table

WASABI model: 
Z(w) = abs(c-d*sin(atan((B1/((freq/gamma_)))/(w-dB0))).^2*sin(sqrt((B1/((freq/gamma_))).^2+(w-dB0).^2)*freq*(2*pi)*t_p/2).^2)

written in 2024-1008, Huabin Zhang, huabinz@connect.hku.hk
ref: Schuenke, P., et al. (2017). "Simultaneous mapping of water shift and B1 (WASABI)—application 
    to field‐inhomogeneity correction of CEST MRI data." Magnetic resonance in medicine 77(2): 571-580.
%}

function [fitresult,Z_fitlist] = WASABI_fit(Zabs, offs, tp, B0, B1pwr)
% INPUT
%   Zabs: [nf,Npixel], non-negative value
%   offs: [nf,1], unit ppm
%   tp: pulse duration, in ms (default is 5 ms)
%   B0: main field of scanner, in T
%   B1pwr: RF power, in uT
% OUTPUT
%   fitresult: [4,Npixel], fitted 4 WASABI paras: [c,d,B1,dB0]
%       dB0: in ppm
%       B1: in uT
%   Z_fitlist: [nf,Npixel], fitted Z-spectra

%% setting
% define 4 variables in WASABI model:
B1_bib = (0.8:0.01:1.2)*B1pwr; % B1 value
dB0_bib = (-0.5:0.01:0.5); % water frequency offset (B0 inhomogenity), ppm
c_bib = (0.2:0.1:1); % accounting for T1/T2 relaxation
d_bib = (0.5:0.1:2.0); % accounting for T1/T2 relaxation
tp_s = tp*10^-3; % s
GAMMA = 2*pi*42.576375; %(rad*Hz/uT) = (rad*MHz/T)
[nf,Npixel] = size(Zabs);

% fun_WASABI = @(c,d,dB0,B1) abs(c - d .* reshape(sin(atan( B1/B0./(offs-dB0) )).^2,[],1) .* ...
%     reshape(sin( GAMMA * sqrt( B1.^2 + B0^2*(offs-dB0).^2 ) *tp_s/2 ).^2,[],1));
fun_WASABI = @(c,d,dB0,B1) c - d .* reshape(sin(atan( B1/B0./(offs-dB0) )).^2,[],1) .* ...
    reshape(sin( GAMMA * sqrt( B1.^2 + B0^2*(offs-dB0).^2 ) *tp_s/2 ).^2,[],1);

%% generate lookup table
tablesize = length(B1_bib)*length(dB0_bib)*length(c_bib)*length(d_bib);
zbib_WASABI = zeros(tablesize,nf);
bib_entries = cell(tablesize,1);
cnt = 1;
fprintf('generating lookup table\n')
for ii=1:length(B1_bib)
    for jj=1:length(dB0_bib)
        for kk=1:length(c_bib)
            for ll=1:length(d_bib)
                B1 = B1_bib(ii);
                dB0 = dB0_bib(jj);
                c = c_bib(kk);
                d = d_bib(ll);
                zbib_WASABI(cnt,:) = fun_WASABI(c,d,dB0,B1);
                bib_entries{cnt} = [c,d,dB0,B1];
                cnt = cnt + 1;
            end
        end
    end
end
fprintf("lookup table successfully generated\n")

%% WASABI model fitting
fitresult = zeros(4, Npixel); % [c,d,B1(uT),B0(ppm)]
Z_fitlist = zeros(nf, Npixel);

backNum = 0;
tic
for i = 1:Npixel
    fprintf(repmat('\b',1,backNum));
    backNum = fprintf('Calculation process: %d/%d',i,Npixel);

    % minimum search
    zspec_diff = zbib_WASABI - reshape(Zabs(:,i),1,[]);
    zspec_diff = sum(abs(zspec_diff),2); % [nB1*ndb0*nc*na,1]

    [~,INDEX] = min(zspec_diff(:));
    para_opt = bib_entries{INDEX};
    c = para_opt(1);
    d = para_opt(2);
    dB0 = para_opt(3);
    B1 = para_opt(4);

    % save data
    fitresult(:,i) = [c;d;B1;dB0];
    Z_fitlist(:,i) = fun_WASABI(c,d,dB0,B1);
    % figure(1);plot(offs,Z_fitlist(:,i),offs,Zabs(:,i));pause(.5)

    % if i==300
    %     fprintf('\n %.4f s\n',toc);
    %     backNum = 0;
    % end
end

fprintf(repmat('\b',1,backNum));
fprintf('elapsed time: %.4f s\n', toc);

end