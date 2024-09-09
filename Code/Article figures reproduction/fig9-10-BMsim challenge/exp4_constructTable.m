% construct BMsim data table from CESTsimu result and PulseqCEST result
clear


%% CESTsimu
% import from saved data
load("BMsim_CESTsimuData_20240827.mat","zspecHoldonCell")
% zspecHoldonCell: [1,8] cell from case 1 to case 8
%   [nf,2] array: [offs, zspec_CESTsimu]

%% PulseqCEST
% manually resorted into MAT file
load("BMsim_PulseqData_20240827.mat","BMsimchallenge_Pulseq")
% BMsimchallenge_Pulseq: [1,8] cell from case 1 to case 8
%   [nf,2] array: [offs, zspec_Pulseq]

%% construct and output
% BMsimchallenge: [1,8] cell from case 1 to case 8
%   [nf,3] array: [offs, zspec_CESTsimu, zspec_PulseqCEST]
for i = 1:8
    CESTsimu = zspecHoldonCell{i};
    Pulseq = BMsimchallenge_Pulseq{i};
    BMsimchallenge{i} = [CESTsimu,Pulseq(:,2)];
end
save("BMsimchallenge_20240827.mat","BMsimchallenge",'-mat')
fprintf("data table is constructed and saved\n")