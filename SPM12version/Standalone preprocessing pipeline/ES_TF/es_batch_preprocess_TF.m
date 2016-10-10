%% Set up global variables

es_batch_init_TF; 

%% Specify preprocessing parameters

%p.mod = {'MEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
p.mod = {'MEGPLANAR'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'EEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'MEG' 'MEGPLANAR' 'EEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'Source'};

% cell array of experimental conditions (used by 'definetrials','convert+epoch' and 'sort' steps)
p.conditions = conditions;

%p.montage_fname = 'montage_MEG_custom.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
p.montage_fname = 'montage_MEGPLANAR_custom.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
%p.montage_fname = 'montage_EEG_custom.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)
%p.montage_fname = 'montage_all_custom.mat'; % channel montage (used by 'convert','convert+epoch','artifact_ft','rereference' steps)

p.fs = 1000; % sample rate for raw data
p.fs_new = 250; % sample rate for processed data 

% for trial definitions
p.preEpoch = -500; % pre stimulus time (ms)
p.postEpoch = 1500; % post stimulus time (ms)
p.delay = 13; % delay time (ms) between trigger and stimulus
p.stimuli_list_fname = 'stimuli_list.txt';

% for conversion into spm format
%p.padding = 1000; % padding around stimulus (ms) that will be included in epochs (for filtering)
p.padding = 0; % padding around stimulus (ms) that will be included in epochs (for filtering)

% for averaging
p.robust = 0;

% for baseline correction
p.preBase = -100; % pre baseline time (ms)
p.postBase = 0; % post baseline time (ms)

% for filtering
%p.filter = 'low'; % type of filter (lowpass or highpass)- never bandpass!
%p.freq = 40; % filter cutoff (Hz)
%p.filter = 'high'; % type of filter (lowpass or highpass)- never bandpass!
%p.freq = 0.5; % filter cutoff (Hz)
p.filter = 'stop';
p.freq = [48 52];

% for artifect rejection (fieldtrip)
% p.type = 'EOG'; % detection type (EOG or muscle)
% p.z = 3; % z threshold
% p.feedback = 'yes';
% p.artefactchans = {'EEG002' 'EEG004' 'EEG005' 'EEG006' 'EEG007' 'EEG008' 'EOG061' 'EOG062'};

p.type = 'EOG'; % detection type (EOG or muscle)
p.z = zthresh; % z threshold
p.feedback = 'no';
p.artefactchans = {'EEG002' 'EEG004' 'EEG005' 'EEG006' 'EEG007' 'EEG008' 'EOG061' 'EOG062'};

% p.type = 'muscle'; % detection type (EOG or muscle)
% p.z = 20; % z threshold
% p.feedback = 'no';
% p.artefactchans = {'EEG*'};
% EOG061 EOG062 horiztonal and vertical EOG
% EEG004 EEG08 replacement horiztonal EOG
% EEG005 EEG007 replacement vertical EOG

% for artefact rejection (SPM)
%p.badchanthresh = 0.3;
%p.thresh = 150e-6;
%p.artefactchans = {'EOG' 'EEG'};

% for computing contrasts of grand averaged MEEG data
p.contrast_labels = contrast_labels;
p.contrast_weights = contrast_weights;

% for time-frequency analysis
%p.method = 'ft_mtmconvol'; p.freqs = [30:2:90]; p.timeres = 200; p.timestep = 20; p.freqres = 10;
p.method = 'morlet';
%p.ncycles = 7;
%p.freqs = [52:2:90];
%p.freqs = [31:48];
%p.ncycles = 4;
%p.freqs = [4:30];
p.ncycles = 7;
p.freqs = [4:90];
p.phase = 1;
%p.preBase_tf = -0.2; % pre baseline time (s) for TF data
%p.postBase_tf = -0.15; % % post baseline time (s) for TF data
% p.tf_chans = {'MEG0132' 'MEG0133' % channels to do TF transform on (dont specify if all channels required)
%               'MEG0142' 'MEG0143'
%               'MEG0212' 'MEG0213'
%               'MEG0222' 'MEG0223'
%               'MEG0232' 'MEG0233'
%               'MEG0242' 'MEG0243'
%               'MEG0322' 'MEG0323'
%               'MEG1512' 'MEG1513'
%               'MEG1522' 'MEG1523'
%               'MEG1542' 'MEG1543'
%               'MEG1612' 'MEG1613'
%               'MEG1622' 'MEG1623'
%               'MEG1812' 'MEG1813'};
p.tf_roi_image = 5; % Average over all channels
p.tf_chans_image = 'all';
% p.tf_roi_image = 1; % MEG left frontal ROI number
% p.tf_chans_image = {'MEG0121'
%                     'MEG0131'
%                     'MEG0141'
%                     'MEG0211'
%                     'MEG0221'
%                     'MEG0311'
%                     'MEG0321'
%                     'MEG0331'
%                     'MEG0341'
%                     'MEG0511'
%                     'MEG0541'
%                     'MEG1511'};
% p.tf_roi_image = 2; % MEG right frontal ROI number
% p.tf_chans_image = {'MEG0931'
%                     'MEG1111'
%                     'MEG1121'
%                     'MEG1211'
%                     'MEG1221'
%                     'MEG1231'
%                     'MEG1241'
%                     'MEG1311'
%                     'MEG1321'
%                     'MEG1331'
%                     'MEG1341'
%                     'MEG1441'
%                     'MEG2611'};
% p.tf_roi_image = 3; % MEG left frontal ROI number
% p.tf_chans_image = {'MEG0341'};
% p.tf_roi_image = 1; % MEGPLANAR left ROI number
% p.tf_chans_image = {'MEG0132' 'MEG0133'
%                     'MEG0142' 'MEG0143'
%                     'MEG0212' 'MEG0213'
%                     'MEG0222' 'MEG0223'
%                     'MEG0232' 'MEG0233'
%                     'MEG0242' 'MEG0243'
%                     'MEG0322' 'MEG0323'
%                     'MEG1512' 'MEG1513'
%                     'MEG1522' 'MEG1523'
%                     'MEG1542' 'MEG1543'
%                     'MEG1612' 'MEG1613'
%                     'MEG1622' 'MEG1623'
%                     'MEG1812' 'MEG1813'};
% p.tf_roi_image = 2; % MEGPLANAR left ROI number
% p.tf_chans_image = {'MEG0132' 'MEG0133'
%                     'MEG0242' 'MEG0243'};
%p.tf_roi_image = 3; % MEGPLANAR left ROI number
%p.tf_chans_image = {'MEG0242' 'MEG0243'};
% p.tf_roi_image = 1; % EEG left frontal ROI number
% p.tf_chans_image = {'EEG001'
%                     'EEG004'
%                     'EEG009'
%                     'EEG010'
%                     'EEG011'
%                     'EEG019'
%                     'EEG020'
%                     'EEG021'
%                     'EEG030'
%                     'EEG031'};
% p.tf_roi_image = 2; % EEG posterior central ROI number
% p.tf_chans_image = {'EEG033'
%                     'EEG034'
%                     'EEG043'
%                     'EEG044'
%                     'EEG045'
%                     'EEG046'
%                     'EEG052'
%                     'EEG053'
%                     'EEG054'
%                     'EEG055'
%                     'EEG056'
%                     'EEG059'
%                     'EEG066'
%                     'EEG067'
%                     'EEG068'
%                     'EEG069'
%                     'EEG070'
%                     'EEG071'
%                     'EEG072'
%                     'EEG073'};

% frequencies over which to average when converting TF data to images (Hz)
%p.tf_freqs_image = [];

% for image smoothing
% p.xSmooth = 3; % smooth for x dimension (Hz)
% p.ySmooth = 50; % smooth for y dimension (ms)
% p.zSmooth = 1;
p.xSmooth = 10;
p.ySmooth = 10;
p.zSmooth = 10;

% for making image mask
p.preImageMask = 0; % pre image time (ms)
p.postImageMask = 1000; % post image time (ms)

% time windows over which to average for 'first-level' contrasts (ms)
p.windows = [90 130; 180 240; 270 420; 450 700];

%% Event-related preprocessing steps

% note: should high-pass filter or baseline-correct before lowpass fitering
% to avoid ringing artefacts

%es_preprocess_TF('maxfilter','',p,pathstem,subjects,dates,blocksin,blocksout,rawpathstem);
%es_preprocess_TF('definetrials','maxfilter',p,pathstem,subjects);
%es_preprocess_TF('artefact_ft','maxfilter',p,pathstem,subjects,dates,blocksin,blocksout,rawpathstem,badeeg);
%es_preprocess_TF('convert+epoch','maxfilter',p,pathstem,subjects,dates,blocksin,blocksout,rawpathstem,badeeg);
%es_preprocess_TF('merge','convert',p,pathstem,subjects);

% MEG
%es_preprocess_TF('baseline','merge',p,pathstem,subjects);

% EEG
%es_preprocess_TF('rereference','merge',p,pathstem,subjects);
%es_preprocess_TF('baseline','rereference',p,pathstem,subjects);
%es_preprocess_TF('filter','baseline',p,pathstem,subjects);

% all modalities (e.g. for source inversion)
%es_preprocess_TF('rereference','merge',p,pathstem,subjects);
%es_preprocess_TF('baseline','rereference',p,pathstem,subjects);

%% Time-frequency preprocessing steps
%es_preprocess_TF('TF','baseline',p,pathstem,subjects); % for MEG
%es_preprocess_TF('TF','filter',p,pathstem,subjects); % for EEG

% Power
%es_preprocess_TF('sort','TF_power',p,pathstem,subjects);
%es_preprocess_TF('average','TF_power',p,pathstem,subjects);
%es_preprocess_TF('image','mtf*.mat',p,pathstem,subjects);

% MEG and EEG
%es_preprocess_TF('weight','mtf*.mat',p,pathstem,subjects);
es_preprocess_TF('grand_average','wmtf*.mat',p,pathstem,subjects);

% MEGPLANAR
%es_preprocess_TF('combineplanar','mtf*.mat',p,pathstem,subjects);
%es_preprocess_TF('weight','pmtf*.mat',p,pathstem,subjects);
%es_preprocess_TF('grand_average','wpmtf*.mat',p,pathstem,subjects);

% Phase
%es_preprocess_TF('sort','TF_phase',p,pathstem,subjects);
%es_preprocess_TF('average','TF_phase',p,pathstem,subjects);
%es_preprocess_TF('image','mtph*.mat',p,pathstem,subjects);
%es_preprocess_TF('smooth','5ROI_phase.img',p,pathstem,subjects);

% MEG and EEG
%es_preprocess_TF('weight','mtph*.mat',p,pathstem,subjects);
%es_preprocess_TF('grand_average','wmtph*.mat',p,pathstem,subjects);

% MEGPLANAR
%es_preprocess_TF('combineplanar','mtph*.mat',p,pathstem,subjects);
%es_preprocess_TF('weight','pmtph*.mat',p,pathstem,subjects);
%es_preprocess_TF('grand_average','wpmtph*.mat',p,pathstem,subjects);

% Other
%es_preprocess_TF('mask','5ROI_power.img',p,pathstem,subjects);
%es_preprocess_TF('image','wpmtph*.mat',p,pathstem,subjects);
%es_preprocess_TF('smooth','bMcspm8_01_raw_ssst*.nii',p,pathstem,subjects);

%% Other preprocessing steps
%es_preprocess_TF('artefact','baseline',p,pathstem,subjects);
%es_preprocess_TF('sort','average',p,pathstem,subjects);
%es_preprocess_TF('erase','tf*.mat',p,pathstem,subjects);
%p.outputstem = '/imaging/es03/P3E1/preprocess4_TF_30_90Hz_MEGPLANAR/'; % for copying files
%es_preprocess_TF('copy','baseline',p,pathstem,subjects);
