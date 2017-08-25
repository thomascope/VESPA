% This is a MEG/EEG preprocessing pipeline developed by Thomas Cope, based on a
% pipeline developed by Ed Sohoglu
%
% It assumes that you have already maxfiltered your data and created a
% trialDef file for each run containing the trial definitions (place these
% appropriately in each folder). I include an example python script to do
% this (you will need to change the paths etc).
%
% Before running, make sure that you have specified the parameters properly
% in this file, in the subjects_and_parameters script, and set the search terms in Preprocessing_mainfunction
% You will also need to move the bundled es_montage_all, tec_montage_all
% and MEGArtifactTemplateTopographies files to your pathstem folder.
% 
% Prerequisites:
% 
% A version of EEGLAB new enough to have the FileIO toolbox (the stock CBU version does not have this; I use 13_3_2b http://sccn.ucsd.edu/eeglab/downloadtoolbox.html )
% NB: You need to set the path to this in the Preprocessing_mainfunction case 'ICA_artifacts'
% The ADJUST toolbox for EEGLAB: (http://www.unicog.org/pm/pmwiki.php/MEG/RemovingArtifactsWithADJUST )
% 
%
% E-mail any questions to tec31@cam.ac.uk



%% Set up global variables

subjects_and_parameters; 
pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_evokedsubtracted_prestimcorrected_fixedICA/';
source_directory = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/';
p.source_directory_forrescale = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/';

%% Specify preprocessing parameters

%p.mod = {'MEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'MEGPLANAR'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'EEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
p.mod = {'MEG' 'MEGPLANAR' 'EEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'Source'};
p.ref_chans = {'EOG061','EOG062','ECG063'}; %Reference channels in your montage in order horizEOG vertEOG ECG (NB: IF YOURS ARE DIFFERENT TO {'EOG061','EOG062','ECG063'} YOU WILL NEED TO MODIFY THE MONTAGE)

% cell array of experimental conditions (used by 'definetrials','convert+epoch' and 'sort' steps)
p.conditions = conditions;

%p.montage_fname = 'es_montage_MEG.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
%p.montage_fname = 'es_montage_MEGPLANAR.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
%p.montage_fname = 'es_montage_EEG.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
% You need to set up some montages with and without the reference
% channels, and put them in the pathstem folder.
p.montage_fname = 'es_montage_all.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
p.montage_rerefname = 'tec_montage_all.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)

p.fs = 1000; % original sample rate
p.fs_new = 250; % sample rate after downsampling in SPM (currently assumes that maxfilter HASN't downsampled data)

% for trial definitions
p.preEpoch = -500; % pre stimulus time (ms)
p.postEpoch = 1500; % post stimulus time (ms)
%p.triggers = [11 10 14 13 17 16]; % trigger values (correspond to p.conditions specified above) % XXX CHANGED FOR NEW BASELINE TO BE THE PRIMES
p.triggers = [2 1 5 4 8 7]; % trigger values (correspond to p.conditions specified above)
p.delay = 32; % delay time (ms) between trigger and stimulus
p.minduration = 950; % if using definetrials_jp, minimum duration of a trial (ms)
p.maxduration = 1150; % if using definetrials_jp, maximum duration of a trial (ms)
%p.stimuli_list_fname = 'stimuli_list.txt';

% for robust averaging
p.robust = 1;

% for baseline correction
p.preBase = -100; % pre baseline time (ms)
p.postBase = 0; % post baseline time (ms)

% for combining planar gradiometer data
p.correctPlanar = 0; % whether to baseline correct planar gradiometer data after RMSing (using baseline period specified in preBase and postBase)

% for filtering 
p.filter = 'low'; % type of filter (lowpass or highpass)- never bandpass!
p.freq = 100; % filter cutoff (Hz)
%p.filter = 'high'; % type of filter (lowpass or highpass)- never bandpass!
%p.freq = 0.5; % filter cutoff (Hz)
% p.filter = 'stop';
% p.freq = [48 52];

% for computing contrasts of grand averaged MEEG data
p.contrast_labels = contrast_labels;
p.contrast_weights = contrast_weights;

% for image smoothing
p.xSmooth = 10; % smooth for x dimension (mm)
p.ySmooth = 10; % smooth for y dimension (mm)
p.zSmooth = 10; % smooth for z (time) dimension (ms)

% for making image mask
p.preImageMask = -100; % pre image time (ms)
p.postImageMask = 950; % post image time (ms)

% time windows over which to average for 'first-level' contrasts (ms)
p.windows = [90 130; 180 240; 270 420; 450 700; 750 900];

% set groups to input
p.group = group;

% set time frequency decomposition parameters
%p.method = 'mtmconvol'; p.freqs = [30:2:90]; p.timeres = 200; p.timestep = 20; p.freqres = 30;
p.freqs = [4:2:80]; %Vector of frequencies of interest
p.method = 'morlet'; %method
p.ncycles = 7; %number of wavelet cycles
p.phase = 1; %save phase information too? (prefixed with tph)
p.tf_chans = 'All'; %cell array of channel names. Can include generic wildcards: 'All', 'EEG', 'MEG' etc.
p.timewin = [-500 1500]; %time window of interest
p.preBase_tf = -100; %TF baseline correct period with below (I don't know why this isn't a two element vector - don't blame me.)
p.postBase_tf = 0;
p.tf.method = 'LogR'; %'LogR', 'Diff', 'Rel', 'Log', 'Sqrt', 'None'
p.tf.subsample = 5; %subsample by a factor of 5 - mainly to save disk space and speed up subsequent processing. Without this, produced a file of 20-40Gb for each subject!

%% Event-related preprocessing steps

% note: should high-pass filter or baseline-correct before lowpass fitering
% to avoid ringing artefacts

% open up a parallel computing pool of appropriate size
% You should pilot one subject and see how much memory is required. This
% currently asks for 8Gb per subject

memoryrequired = num2str(8*size(subjects,1));

try
    try
        matlabpool 'close'
    catch
    end
    currentdr = pwd;
    cd('/group/language/data/thomascope/vespa/SPM12version/')
    
    workerpool = cbupool(size(subjects,2));
    workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=168:00:00'];
    matlabpool(workerpool)
    cd(currentdr)

catch
    fprintf([ '\n\nUnable to open up a worker pool - running serially rather than in parallel' ]);
end

parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('ICA_artifacts_copy','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, source_directory)
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('subtractevoked','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, source_directory)
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('TF','subtractevoked',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('average','TF_power',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end


parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('TF_rescale_differentfolder','mtf_evc*dMrun*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, source_directory);
end
Preprocessing_mainfunction('grand_average','TF_rescale',p,pathstem, maxfilteredpathstem, subjects);
parfor cnt = 1:size(subjects,2)    
   Preprocessing_mainfunction('weight','TF_rescale',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
Preprocessing_mainfunction('grand_average','wrmtf_evc*.mat',p,pathstem, maxfilteredpathstem, subjects);
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('image','TF_rescale',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    % The input for smoothing should be the same as the input used to make
    % the image files.
    Preprocessing_mainfunction('smooth','TF_rescale',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
for cnt = 1
    % The input for smoothing should be the same as the input used to make
    % the image files. Only need to do this for a single subject
    Preprocessing_mainfunction('mask','TF_rescale',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end

%% New test section to contrast extracted LFPs from beaformer. Need to have run LCMV_source_extraction_2016 for this to work
% 
% 
% Preprocessing_mainfunction('grand_average','Bceff*.mat',p,pathstem, maxfilteredpathstem, subjects);
% parfor cnt = 1:size(subjects,2)    
%    Preprocessing_mainfunction('weight','Bceff*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
% end
% Preprocessing_mainfunction('grand_average','wBceff*.mat',p,pathstem, maxfilteredpathstem, subjects);
% parfor cnt = 1:size(subjects,2)
%     Preprocessing_mainfunction('image','Bceff*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
% end
% parfor cnt = 1:size(subjects,2)
%     % The input for smoothing should be the same as the input used to make
%     % the image files.
%     Preprocessing_mainfunction('smooth','Bceff*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
% end
% for cnt = 1
%     % The input for smoothing should be the same as the input used to make
%     % the image files. Only need to do this for a single subject
%     Preprocessing_mainfunction('mask','Bceff*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
% end



matlabpool 'close';