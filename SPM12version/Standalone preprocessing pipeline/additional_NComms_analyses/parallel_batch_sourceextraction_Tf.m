function parallel_batch_sourceextraction_Tf(s)

%A new script to extract the source timeseries from existing source
%reconstructions to satistfy nature comms reviewers
% Reconstruction of interest: val = 5; LORETA multimodal
% VOIs of interest from univariate contrast: -46,2,28 (frontal); -56,-34,12 (temporal)

addpath('/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/')
subjects_and_parameters;
pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/';

fft_method = 'mtmfft'; % 'wavelet' for morlet; can leave blank for multitaper.
%method = 'granger';
method = 'coh';

%for time = 1:3
for time = 3
%for time = [1,3]
%for time = 1
    if time == 3
        tf_pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/'; %For spoken word baseline
        outdir = [pathstem 'extractedsources_tf_icoh/'];
        %outdir = [pathstem 'extractedsources_tf/'];
        start_times = 32;
        end_times = 944;
    elseif time == 2
        tf_pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/'; %For written word baseline
        %outdir = [pathstem 'extractedsources_tf_newinversions_newbaseline_icoh/'];
        outdir = [pathstem 'extractedsources_tf_newinversions_newbaseline/'];
        start_times = 32;
        end_times = 944;
    else
        tf_pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_prestimpaddedforgrangernull/'; %For pre-written word baseline
        %outdir = [pathstem 'extractedsources_tf_newinversions_null_icoh/'];
        outdir = [pathstem 'extractedsources_tf_newinversions_null/'];
        start_times = -968;
        end_times = -56;
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
%     clear S D
    
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
%     
%     %for s=1:length(subjects)
%     D = spm_eeg_load([tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat']);
%     D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
%     D.inv{val}.source.label = {'frontal'; 'temporal'};
%     D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_s' num2str(s)];
%     D.inv{val}.source.type = 'trials';
%     D.val = 5;
%     thisdir = pwd;
%     cd([tf_pathstem subjects{s}]);
%     spm_eeg_inv_extract_flexible(D,pathstem)
%     cd(thisdir);
%     clear D
%     %end

    D = spm_eeg_load([tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat']);
    D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
    D.inv{val}.source.label = {'frontal'; 'temporal'};
    D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_evoked_s' num2str(s)];
    D.inv{val}.source.type = 'evoked';
    D.val = 5;
    thisdir = pwd;
    cd([tf_pathstem subjects{s}]);
    %spm_eeg_inv_extract(D)
    %spm_eeg_inv_extract_flexible(D,pathstem)
    cd(thisdir);
    clear D
    
    D = spm_eeg_load([tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat']);
    D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
    D.inv{val}.source.label = {'frontal'; 'temporal'};
    D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_s' num2str(s)];
    D.inv{val}.source.type = 'trials';
    D.val = 5;
    thisdir = pwd;
    cd([tf_pathstem subjects{s}]);
    %spm_eeg_inv_extract(D)
    %spm_eeg_inv_extract_flexible(D,pathstem)
    cd(thisdir);
    clear D
    
%     
% %     %for s=1:length(subjects)
%     D = spm_eeg_load([tf_pathstem subjects{s} '/scratch_unaveraged_extract.mat']);
%     D.inv{val}.source.XYZ = [-46,2,28;-56,-34,12];
%     D.inv{val}.source.label = {'frontal'; 'temporal'};
%     D.inv{val}.source.fname = [outdir 'timeseries_for_coherence_evoked_s' num2str(s)];
%     D.inv{val}.source.type = 'evoked';
%     D.val = 5;
%     thisdir = pwd;
%     cd([tf_pathstem subjects{s}]);
%     spm_eeg_inv_extract_flexible(D,pathstem)
%     cd(thisdir);
%     clear D
% %     %end
%     
    %parallel_tec_granger_source_coherence_tf(s,outdir)
    %parallel_tec_granger_averagesubtracted_bothperms(s,outdir,start_times,end_times,fft_method,method)
    parallel_tec_granger_averagesubtracted_bothperms_highfreq_1000(s,outdir,start_times,end_times,fft_method,method)
    %parallel_tec_granger_averagenotsubtracted_bothperms_highfreq(s,outdir,start_times,end_times,fft_method,method)
end