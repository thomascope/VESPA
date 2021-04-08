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

subjects_and_parameters_follow_up;
pathstem = '/imaging/mlr/users/tc02/vespa_followup/preprocess/SPM12_fullpipeline/';

%% Specify preprocessing parameters

%p.mod = {'MEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'MEGPLANAR'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
%p.mod = {'EEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps)
p.mod = {'MEGMAG' 'MEGPLANAR' 'EEG'}; % imaging modality (used by 'convert','convert+epoch','image','smooth','mask','firstlevel' steps) NB: EEG MUST ALWAYS BE LISTED LAST!!
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
p.freq = 40; % filter cutoff (Hz)
%p.filter = 'high'; % type of filter (lowpass or highpass)- never bandpass!
%p.freq = 0.5; % filter cutoff (Hz)
%p.filter = 'stop';
%p.freq = [48 52];

% for computing contrasts of grand averaged MEEG data
p.contrast_labels = contrast_labels;
p.contrast_weights = contrast_weights;

% for image smoothing
p.xSmooth = 10; % smooth for x dimension (mm)
p.ySmooth = 10; % smooth for y dimension (mm)
p.zSmooth = 25; % smooth for z (time) dimension (ms)

% for making image mask
p.preImageMask = -100; % pre image time (ms)
p.postImageMask = 950; % post image time (ms)

% time windows over which to average for 'first-level' contrasts (ms)
p.windows = [90 130; 180 240; 270 420; 450 700; 750 900];

% set groups to input
p.group = group;
%% Event-related preprocessing steps

% note: should high-pass filter or baseline-correct before lowpass fitering
% to avoid ringing artefacts

% open up a parallel computing pool of appropriate size
% You should pilot one subject and see how much memory is required. This
% currently asks for 4Gb per run

allrunsarray = [];
for i = 1:length(blocksin)
    for j = 1:length(blocksin{i})
        allrunsarray(end+1,:) = [i,j];
    end
end

if size(allrunsarray,1) > 96
    workersrequested = 96;
    fprintf([ '\n\nUnable to ask for a worker per run; asking for 96 instead\n\n' ]);
else
    workersrequested = size(allrunsarray,1);
end

memoryperworker = 8;
if memoryperworker*workersrequested >= 192 %I think you can't ask for more than this - it doesn't seem to work at time of testing anyway
    memoryrequired = '192'; %NB: This must be a string, not an int!!!
    fprintf([ '\n\nUnable to ask for as much RAM per worker as specified due to cluster limits, asking for 192Gb in total instead\n\n' ]);
else
    memoryrequired = num2str(memoryperworker*workersrequested);
end

try
    currentdr = pwd;
    cd('/group/language/data/thomascope/vespa/SPM12version/')
    workerpool = cbupool(workersrequested);
    workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=168:00:00'];
    matlabpool(workerpool)
    cd(currentdr)
catch
    try
        cd('/group/language/data/thomascope/vespa/SPM12version/')
        matlabpool 'close'
        workerpool = cbupool(workersrequested);
        workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=168:00:00'];
        matlabpool(workerpool)
        cd(currentdr)
    catch
        try
            cd('/group/language/data/thomascope/vespa/SPM12version/')
            workerpool = cbupool(workersrequested);
            matlabpool(workerpool)
            cd(currentdr)
        catch
            cd(currentdr)
            fprintf([ '\n\nUnable to open up a cluster worker pool - opening a local cluster instead' ]);
            matlabpool(12)
        end
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
todocomplete = zeros(1,size(todoarray,1));
parfor todonumber = 1:size(todoarray,1)
    cnt = todoarray(todonumber,1);
    runtodo = todoarray(todonumber,2);
    
    %Preprocessing_mainfunction('definetrials','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
    %Defining trials does not seem to work on .fif files in SPM12 for some reason. Perhaps the function names have changed Will
    %need to use SPM8 version for this or define after conversion.
    
    try
        Preprocessing_mainfunction_follow_up('convert','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, runtodo)
        todocomplete(todonumber) = 1
        fprintf('\n\nConversion complete for subject number %d, run number %d\n\n',todoarray(todonumber,1), todoarray(todonumber,2));
    catch
        todocomplete(todonumber) = 0;
        fprintf('\n\nnConversion failed for subject number %d, run number %d\n\n',todoarray(todonumber,1), todoarray(todonumber,2));
    end
end
% icaworkedcorrectly = zeros(1,size(subjects,2));
% parfor cnt = 1:size(subjects,2)
%    try
%    %Preprocessing_mainfunction_follow_up('definetrials','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
%    %Defining trials does not seem to work on .fif files in SPM12 for some reason. Will
%    %need to use SPM8 version for this or define after conversion.
%
%       %Preprocessing_mainfunction_follow_up('convert+epoch','maxfilter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, maxfilteredpathstembadeeg);
%        Preprocessing_mainfunction_follow_up('ICA_artifacts','convert',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg)
%        icaworkedcorrectly(cnt) = 1;
%    catch
%        icaworkedcorrectly(cnt) = 0;
%    end
% end

%p.fixICA = 0; %If you want to fix an errored ICA by using saved decomposition
todoarray = allrunsarray;
todocomplete = zeros(1,size(todoarray,1));
parfor todonumber = 1:size(todoarray,1)
    cnt = todoarray(todonumber,1);
    runtodo = todoarray(todonumber,2);
    try
        Preprocessing_mainfunction_follow_up('ICA_artifacts','convert',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg, badchannels, runtodo)
        todocomplete(todonumber) = 1
        fprintf('\n\nICA complete for subject number %d, run number %d\n\n',todoarray(todonumber,1), todoarray(todonumber,2));
    catch
        todocomplete(todonumber) = 0;
        fprintf('\n\nICA failed for subject number %d, run number %d\n\n',todoarray(todonumber,1), todoarray(todonumber,2));
    end
end

% The first time you run through you should put a breakpoint on pause to check
% that the ICA worked correctly by inspecting todocomplete. The main
% reason for failure is if there are too many missing EEG electrodes for
% ADJUST to work. If this happens, then you can set the code to
% automatically continue without touching the EEG using a try - catch
% statement, or get it to omit EEG for specific subjects (example in the mainfunction) or try to fix it.

% pause

% This next bit is not yet fully parallelised (doesn't seem necessary
% because it doesn't take so long), so re-open a smaller matlab pool with
% one worker per subject to reduce occupation of the cluster
% 
memoryrequired = num2str(4*size(subjects,2));

try
    matlabpool 'close'
    currentdr = pwd;
    cd('/group/language/data/thomascope/vespa/SPM12version/')
    workerpool = cbupool(size(subjects,2));
    workerpool.ResourceTemplate=['-l nodes=^N^,mem=' memoryrequired 'GB,walltime=48:00:00'];
    matlabpool(workerpool)
    cd(currentdr)
catch
    fprintf([ '\n\nUnable to open up a cluster worker pool - opening a local cluster instead' ]);
    matlabpool(12)
end

parfor cnt = 1:size(subjects,2)
    %Preprocessing_mainfunction_follow_up('definetrials','convert',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
    Preprocessing_mainfunction_follow_up('epoch','ICA_artifacts',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt,dates,blocksin,blocksout,rawpathstem, badeeg);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('downsample','epoch',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('rereference','downsample',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('baseline','rereference',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('filter','baseline',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('merge','filter',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('sort','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('average','merge',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('filter','average',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('combineplanar','fmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end

Preprocessing_mainfunction_follow_up('grand_average','pfmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects);
% This saves the grand unweighted average file for each group in the folder of the
% first member of that group. For convenience, you might want to move them
% to separate folders.

parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('weight','pfmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end

Preprocessing_mainfunction_follow_up('grand_average','wpfmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects);
% This saves the grand weighted average file for each group in the folder of the
% first member of that group. For convenience, you might want to move them
% to separate folders.
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('combineplanar_spm','fmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
p.mod = {'MEGMAG' 'MEGCOMB' 'EEG'};
parfor cnt = 1:size(subjects,2)
    Preprocessing_mainfunction_follow_up('image','PfmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
parfor cnt = 1:size(subjects,2)
    % The input for smoothing should be the same as the input used to make
    % the image files.
    Preprocessing_mainfunction_follow_up('smooth','PfmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end
for cnt = 1
    % The input for smoothing should be the same as the input used to make
    % the image files. Only need to do this for a single subject
    Preprocessing_mainfunction_follow_up('mask','PfmcfbMdeMr*.mat',p,pathstem, maxfilteredpathstem, subjects{cnt},cnt);
end



% now move all of the smoothed nifti images into folders marked
% controls/patients, either manually or with copyniftitofolder.py (you will
% need to change the paths and search characteristics appropriately).

matlabpool 'close';