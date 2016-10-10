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
pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_thirdICA/';

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
p.windows = [90 130; 180 240; 270 420; 450 700;];

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

allrunsarray = [];
for i = 1:length(blocksin)
    for j = 1:length(blocksin{i})
        allrunsarray(end+1,:) = [i,j];
    end
end

memoryperworker = 4;
if memoryperworker*size(allrunsarray,1) >= 196 %I think you can't ask for more than this - it doesn't seem to work at time of testing anyway
    memoryrequired = '195'; %NB: This must be a string, not an int
    fprintf([ '\n\nUnable to ask for as much RAM per worker as specified due to cluster limits, asking for 195Gb instead' ]);
else
    memoryrequired = num2str(memoryperworker*size(allrunsarray,1));
end

try
    workerpool = cbupool(size(allrunsarray,1));
    workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=168:00:00'];
    matlabpool(workerpool)
catch
    try
        matlabpool 'close'
        workerpool = cbupool(size(allrunsarray,1));
        workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=168:00:00'];
        matlabpool(workerpool)
    catch
        fprintf([ '\n\nUnable to open up a worker pool - running serially rather than in parallel' ]);
    end
end

%Preprocessing pipeline below. This should be fully modular and intuitive.
%You will need to appropriately change the search terms at the start of the
%mainfunction to look for your dataname. If you change the order, these
%might need editing

%The mainfunction is called with the arguments
%Preprocessing_mainfunction(nextstep, previousstep, p, pathstem, maxfilteredpathstem, subjects{cnt}, cnt[, dates, blocksin, blocksout, rawpathstem, badeeg])
% previousstep can be specified using a name in the switch-case section of
% the mainfunction, or by entering a text searchstring (examples of each
% are below).

% Any functions present in the mainfunction and not listed below have not
% been optimised for SPM12 so will need some debugging before they will
% work.
    
todoarray = allrunsarray;
parfor todonumber = 1:size(todoarray,1)
   cnt = todoarray(todonumber,1);
   runtodo = todoarray(todonumber,2);
   
   %Preprocessing_mainfunction('definetrials','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
   %Defining trials does not seem to work on .fif files in SPM12 for some reason. Perhaps the function names have changed Will
   %need to use SPM8 version for this or define after conversion.   
   
   Preprocessing_mainfunction('convert','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, runtodo)
end
% icaworkedcorrectly = zeros(1,size(subjects,2));
% parfor cnt = 1:size(subjects,2)
%    try
%    %Preprocessing_mainfunction('definetrials','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
%    %Defining trials does not seem to work on .fif files in SPM12 for some reason. Will
%    %need to use SPM8 version for this or define after conversion.
%    
%       %Preprocessing_mainfunction('convert+epoch','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, maxfilteredpathstembadeeg);
%        Preprocessing_mainfunction('ICA_artifacts','convert',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg)
%        icaworkedcorrectly(cnt) = 1;
%    catch
%        icaworkedcorrectly(cnt) = 0;
%    end
% end

todoarray = allrunsarray;
todocomplete = zeros(1,size(todoarray,1));
parfor todonumber = 1:size(todoarray,1)
   cnt = todoarray(todonumber,1);
   runtodo = todoarray(todonumber,2);
   try
   %Preprocessing_mainfunction('definetrials','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
   %Defining trials does not seem to work on .fif files in SPM12 for some reason. Will
   %need to use SPM8 version for this or define after conversion.      
       Preprocessing_mainfunction('ICA_artifacts','convert',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, runtodo)
       todocomplete(todonumber) = 1
       fprintf('\n\nICA complete for subject number %d, run number %d\n\n',todoarray(todonumber,1), todoarray(todonumber,2));
   catch
       todocomplete(todonumber) = 0;
       fprintf('\n\nICA failed for subject number %d, run number %d\n\n',todoarray(todonumber,1), todoarray(todonumber,2));
   end
end

% The first time you run through you should put a breakpoint on pause to check
% that the ICA worked correctly by inspecting icaworkedcorrectly. The main
% reason for failure is if there are too many missing EEG electrodes for
% ADJUST to work. If this happens, then you can set the code to
% automatically continue without touching the EEG using a try - catch
% statement, or get it to omit EEG for specific subjects (example in the mainfunction) or try to fix it.

% pause

% This next bit is not yet fully parallelised (doesn't seem necessary
% because it doesn't take so long), so re-open a smaller matlab pool with
% one worker per subject to reduce occupation of the cluster

memoryrequired = num2str(4*size(subjects,1));

try
    try
        matlabpool 'close'
    catch
    end
    workerpool = cbupool(size(subjects,2));
    workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=48:00:00'];
    matlabpool(workerpool)
catch
    fprintf([ '\n\nUnable to open up a worker pool - running serially rather than in parallel' ]);
end

parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('downsample','ICA_artifacts',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('rereference','downsample',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('baseline','rereference',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('filter','baseline',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end

%to filter at 50Hz too.
p.filter = 'stop';
p.freq = [48 52];
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('filter','filter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
   Preprocessing_mainfunction('epoch','secondfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('merge','epoch',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('sort','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('average','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('filter','average',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2) 
    Preprocessing_mainfunction('combineplanar','fmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end

Preprocessing_mainfunction('grand_average','pfmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects);
% This saves the grand unweighted average file for each group in the folder of the
% first member of that group. For convenience, you might want to move them
% to separate folders.

parfor cnt = 1:size(subjects,2)    
   Preprocessing_mainfunction('weight','pfmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end

Preprocessing_mainfunction('grand_average','wpfmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects);
% This saves the grand weighted average file for each group in the folder of the
% first member of that group. For convenience, you might want to move them
% to separate folders.
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('image','fmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    % The input for smoothing should be the same as the input used to make
    % the image files.
    Preprocessing_mainfunction('smooth','fmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
for cnt = 1
    % The input for smoothing should be the same as the input used to make
    % the image files. Only need to do this for a single subject
    Preprocessing_mainfunction('mask','fmceffbMdMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end  

% now, if you want to simplify, you can move all of the smoothed nifti images into folders marked
% controls/patients, either manually or with copyniftitofolder.py (you will
% need to change the paths and search characteristics appropriately).
% Alternatively, you can use recursive search in your analysis scripts

%Time frequency analysis
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('TF','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('average','TF_power',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
p.robust = 0; %robust averaging doesn't work for phase data
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('average','TF_phase',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
p.robust = 1; % just in case we want to do any more averaging later
%TF_rescale to baseline correct the induced power data only
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction('TF_rescale','mtf_c*dMrun*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
Preprocessing_mainfunction('grand_average','TF_rescale',p,pathstem, maxfilteredpathstem, subjects);
parfor cnt = 1:size(subjects,2)    
   Preprocessing_mainfunction('weight','TF_rescale',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
Preprocessing_mainfunction('grand_average','wrmtf_c*.mat',p,pathstem, maxfilteredpathstem, subjects);
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

%Now to do the higher frequencies with multitapers! - If you want to do
%this, you must copy the merged files, to another folder appended with '_taper' and re-run from
%the appropriate step above

pathstem = [pathstem(1:end-1) '_taper/'] ; 
p.method = 'mtmconvol'; 
p.freqs = [30:2:90]; 
p.timeres = 200; 
p.timestep = 20; 
p.freqres = 30; %Suggestion from Markus Bauer to use this very broad frequency smoothing. I guess it makes sense if we're expecting large individual differences in gamma frequency




matlabpool 'close';