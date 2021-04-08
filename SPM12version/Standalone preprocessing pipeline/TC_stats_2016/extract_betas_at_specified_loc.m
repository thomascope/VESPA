function [R, p] = extract_betas_at_specified_loc(freq,time,SPM,type)
%[PearsonsR, p] = extract_betas_at_specified_loc(24,992,'/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/stats_tf_newbaseline_shortenedsm_/combined_-100_1000_MEGPLANAR/SPM.mat')

if ~exist('type','var')
    type = 'Pearson'
end
    

load(SPM);
patientbetas = zeros(1,10);
controlbetas=zeros(1,11);
datahere = spm_get_data(SPM.xY.VY,[(freq-2)/2,(time+504)/4,1]');
for i = 1:10
patientbetas(i) = mean(datahere(66+i:10:end));
end
for i = 1:11
controlbetas(i) = mean(datahere(i:11:66));
end



controlpriorsd = [
    1.4079
    1.2169
    2.1994
    1.6734
    0.5518
    2.4551
    2.3795
    2.3784
    1.9396
    1.6079
    1.6246];

%New Bayesian model outputs
controlpriorsd = [
    1.2558
    1.2136
    1.9481
    1.5141
    0.5518
    2.2488
    1.5996
    1.8240
    1.6211
    1.6079
    1.4622];

patientpriorsd = [    0.2085
    0.0773
    2.2592
    1.2197
    1.3367
    0.1130
    0.3311
    0.5099
    0.1870
    1.5687];

%New Bayesian model outputs
patientpriorsd = [
    0.1850
    0.0773
    1.7831
    1.2197
    1.3367
    0.0983
    0.2766
    0.5099
    0.1681
    1.5509];

[R, p] = corr([controlbetas,patientbetas]',[controlpriorsd;patientpriorsd],'type',type);