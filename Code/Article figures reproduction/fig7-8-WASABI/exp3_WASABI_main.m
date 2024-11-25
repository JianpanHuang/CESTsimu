% Load CESTsim app data, compare WASABI/Fast-WASABI result

%% load data and setting
filename = "CESTsimudata_WASABI-2D";

load(filename,'img','dataInfo','roi','img_m0','offs');
B0map = dataInfo.saturation.B0inhomo_ppm;
B1map = dataInfo.saturation.B1inhomo_relative;
img_cest = img;
%   B0map: [128,128]
%   B1map: [256,256]
%   amidef: [1,9]
%   img_cest: [384,384,41]
%   img_m0: [384,384], range [0,1]
%   offs: [1,41], not include m0

zmap = abs(img_cest./(img_m0+eps).*roi);
B1pwr = 3.7; % uT
B0 = 3; % main field of scanner
tp = 5; % ms
nf = length(offs);

%% WASABI fitting
tic

Z_vec = reshape(permute(zmap,[3,1,2]),nf,[]); % [nf,Npixel]
roi_vec = reshape(roi,[],1);
indnz = find(roi_vec~=0);

cmap_WASABI = zeros(size(img_m0));
afmap_WASABI = zeros(size(img_m0));
B0map_WASABI = zeros(size(img_m0));
B1map_WASABI = zeros(size(img_m0));
zmap_WASABI  = zeros(size(img));

% WASABI
[fitresult_nz, zfit] = WASABI_fit_parallel(Z_vec(:,indnz), offs(:), tp, B0, B1pwr); % only fit non-zero pixel
cmap_WASABI(indnz) = fitresult_nz(1,:);
afmap_WASABI(indnz) = fitresult_nz(2,:);
B1map_WASABI(indnz) = fitresult_nz(3,:);
B0map_WASABI(indnz) = fitresult_nz(4,:);
for i = 1:nf
    zmapTemp = zeros(size(img_m0));
    zmapTemp(indnz) = zfit(i,:);
    zmap_WASABI(:,:,i) = zmapTemp;
end

save("WASABI_result.mat",'B0map','B0map_WASABI','B1map','B1map_WASABI','cmap_WASABI','afmap_WASABI','-mat');

elapsedTime = toc;
fileID = fopen('runtime_log.txt', 'w');
fprintf(fileID, 'WASABI execution time: %.4f seconds.\n', elapsedTime);
fclose(fileID);
