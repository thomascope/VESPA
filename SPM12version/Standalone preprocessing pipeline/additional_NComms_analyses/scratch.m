function scratch(s)

%A new script to extract the source timeseries from existing source
%reconstructions to satistfy nature comms reviewers
% Reconstruction of interest: val = 5; LORETA multimodal
% VOIs of interest from univariate contrast: -46,2,28 (frontal); -56,-34,12 (temporal)

addpath('/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/')
subjects_and_parameters;
pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/';

fft_method = 'mtmfft'; % 'wavelet' for morlet XXX crashes - needs work; can leave blank for multitaper.
method = 'coh';

for time = 1
    if time == 3
        tf_pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/'; %For spoken word baseline
        outdir = [pathstem 'extractedsources_tf_icoh/'];
    elseif time == 2
        tf_pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/'; %For written word baseline
        outdir = [pathstem 'extractedsources_tf_newbaseline_icoh/'];
    else
        tf_pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_prestimpaddedforgrangernull/'; %For pre-written word baseline
        outdir = [pathstem 'extractedsources_tf_null_icoh/'];
    end
    
    targetfile = 'fmcfbMdeMrun1_raw_ssst.mat';
    targetfilesplit = 'fmcfbMdeMrun1_1_raw_ssst.mat';
    
    tf_file = 'ceffbMdMrun1_raw_ssst.mat';
    tf_filesplit = 'ceffbMdMrun1_1_raw_ssst.mat';
    
    val = 5; %5th inversion
    
    % for s=1:length(subjects)
    %
    if exist([pathstem subjects{s} '/' targetfile],'file');
        S.D = [pathstem subjects{s} '/' targetfile];
        unaveragedfile = [tf_pathstem subjects{s} '/' tf_file];
    elseif exist([pathstem subjects{s} '/' targetfilesplit],'file');
        S.D = [pathstem subjects{s} '/' targetfilesplit];
        unaveragedfile = [tf_pathstem subjects{s} '/' tf_filesplit];
    else
        error([pathstem subjects{s} ' does not contain the target file'])
    end
    
%     D = spm_eeg_load(S.D);
%     inversion = D.inv;
%     
    clear S D
    
    S.D = unaveragedfile;
    S.outfile = [tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat'];
%     spm_eeg_copy(S) %For safety
%     
%     D = spm_eeg_load(S.outfile);
%     D.inv = inversion;
%     D.save
    
    
    if ~exist(outdir,'dir')
        mkdir(outdir)
    end
    
    %for s=1:length(subjects)
    D = spm_eeg_load([tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat']);
    D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
    D.inv{val}.source.label = {'frontal'; 'temporal'};
    D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_s' num2str(s)];
    D.inv{val}.source.type = 'trials';
    D.val = 5;
    %spm_eeg_inv_extract_flexible(D)
    clear D
    %end
    
    %for s=1:length(subjects)
    D = spm_eeg_load([tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat']);
    D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
    D.inv{val}.source.label = {'frontal'; 'temporal'};
    D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_evoked_s' num2str(s)];
    D.inv{val}.source.type = 'evoked';
    D.val = 5;
    %spm_eeg_inv_extract_flexible(D)
    clear D
    %end
    
    %parallel_tec_granger_source_coherence_tf(s,outdir)
    parallel_tec_granger_source_coherence_unaveraged_tf(s,outdir,fft_method,method)
end