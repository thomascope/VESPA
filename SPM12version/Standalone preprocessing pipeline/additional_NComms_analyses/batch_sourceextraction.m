%A new script to extract the source timeseries from existing source
%reconstructions to satistfy nature comms reviewers
% Reconstruction of interest: val = 5; LORETA multimodal
% VOIs of interest from univariate contrast: -46,2,28 (frontal); -56,-34,12 (temporal)

addpath('/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/')
subjects_and_parameters;
pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/';

targetfile = 'fmcfbMdeMrun1_raw_ssst.mat';
targetfilesplit = 'fmcfbMdeMrun1_1_raw_ssst.mat';

backupfile = 'scratch_extract.mat'; %First copy the existing MEG file so that we don't mess it up
val = 5; %5th inversion

% for s=1:length(subjects)
%     
%     if exist([pathstem subjects{s} '/' targetfile],'file');
%         S.D = [pathstem subjects{s} '/' targetfile];
%     elseif exist([pathstem subjects{s} '/' targetfilesplit],'file');
%         S.D = [pathstem subjects{s} '/' targetfilesplit];
%     else
%         error([pathstem subjects{s} ' does not contain the target file'])
%     end 
%        
%     S.outfile = [pathstem subjects{s} '/scratch_extract.mat'];
%     spm_eeg_copy(S) %For safety
%     
% end

outdir = [pathstem 'extractedsources/'];
if ~exist(outdir,'dir')
    mkdir(outdir)
end

for s=1:length(subjects)
    D = spm_eeg_load([pathstem subjects{s} '/scratch_extract.mat']);
    D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
    D.inv{val}.source.label = {'frontal'; 'temporal'};
    D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_s' num2str(s)];
    D.inv{val}.source.type = 'trials';
    D.val = 5;
    spm_eeg_inv_extract_flexible(D)
    clear D
end

for s=1:length(subjects)
    D = spm_eeg_load([pathstem subjects{s} '/scratch_extract.mat']);
    D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
    D.inv{val}.source.label = {'frontal'; 'temporal'};
    D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_evoked_s' num2str(s)];
    D.inv{val}.source.type = 'evoked';
    spm_eeg_inv_extract_flexible(D)
    D.val = 5;
    clear D
end

