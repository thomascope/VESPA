clear all
clc

es_batch_init_MMN

% Uncomment for the first run in MATLAB:
addpath(genpath('/imaging/local/spm/spm8'));
addpath(genpath('/imaging/local/software/mne'));

% File Containing CHANNEL INFORMATION for MEG and EEG (e.g. '/imaging/meg.ryan/Batch/chan_select_MEG_EEG_STI101.mat')
chanfile = '/imaging/tc02/vespa/preprocess/es_montage_all.mat'; % change to your where channel.mat is located

%% Define EVENT INFO

epoch  = [-400 400];    % EPOCH around subject responses for averaging (milliseconds)

% define conditions
con_labels = {'spec_all', 'free_all', 'spec_ind', 'spec_mid', 'spec_ring', 'spec_lit',  'free_ind', 'free_mid', 'free_ring', 'free_lit'};    % Labels of conditions corresponding to trigger codes

offset = zeros(1,10);             % OFFSET between trigger and stimulus presentation, e.g. projector delay (milliseconds)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The rest should run smoothly...   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nr_sbjs = length(subjects); % number of subjects

%% Matlab pool stuff (run subjects in parallel (max 64 machines can be used per user at any one time)

%ParType = 0;  % Fun on Login machines (not generally advised!)
%ParType = 1;   % Run maxfilter call on Compute machines using spmd (faster)
ParType = 2;   % Run on multiple Compute machines using parfar (best, but less feedback if crashes)
% 
% open matlabpool if required
% matlabpool close force CBU_Cluster
% if ParType
%     if matlabpool('size')==0;
%         %MaxNsubs = 1;
%         %if ParType == 2
%         %    for g=1:length(cbu_codes)
%         %        MaxNsubs = max([MaxNsubs length(cbu_codes{g})]);
%         %    end
%         %end
%         P = cbupool(10); % change to the number of subjs provided <64
%         matlabpool(P);
%     end
% end
cbupool(nr_sbjs)

TransDefaultFlag = 1; 
%% loop over subjects:
parfor ss = 1:nr_sbjs
    % Cd to current subject directory
    subjfolder = sprintf('/imaging/tc02/vespa/preprocess/%s/MMN+Rest',subjects{ss});
    cd(subjfolder)
    
    
    efile = {};
    nr_sess = length( blocksin{ss} );
    
    %clear S D;
    
    swd = fullfile(bwd,subjects{ss});
    fprintf(1, 'Subject: %s\n', swd);
%     try
%         eval(sprintf('!mkdir %s',swd))
%     end

    mkdir(swd)
    cd(swd)
    
    % Loop over blocks:
    for ses = 1:nr_sess
        %clear refs
        
        % Find Maxfiltered files:
        rawfile  = fullfile(rawpathstem,subjects{ss},sprintf('/MMN+Rest/%s_raw_ssst.fif',blocksin{ss}{ses}));
        
        fprintf(1, 'Processing %s\n', rawfile);
                
        S = [];
        S.dataset  = rawfile;
        S.outfile  = fullfile(bwd,subjects{ss},blkout{ss}{ses})
        
        tmp = load(chanfile);
        S.channels = tmp.montage.labelorg;
        
        %% Convert:
        D = spm_eeg_convert(S);
        
        % for some reason fiducials disappear in blocks later on... use
        % this to put them back in again:
        if  ses ==1
            blk1_fid = D.fiducials;
        else
            D = fiducials(D, blk1_fid);
        end
        
        ch = find(strcmp(D.chanlabels,'STI101'));
        D(ch,:,:) = D(ch,:,:)/10^7;   % Downscale trigger channel so easier to see EOG when display "Other" channels
        
        
               
%          % Prepare channels - change channel types to EOG (EEG061 & EEG062) and ECG (EEG063)
%          %doesn't work with parallel forloop so may have to do manually.
%         load(D.fname) % load D so as to have a struct I can deal with:
%         
%         % Search for Channel names
%         for i = 1:size(D.channels(1,:),2)
%            
%             S = [];
%             S.D = D.fname;
%             S.task = 'settype';
%             
%             % Search for EOG, ECG and 'Other' channels to make sure they
%             % are marked properly:
%             if strcmp(D.channels(1,i).label, 'EEG061')|| strcmp(D.channels(1,i).label, 'EEG062')
%                 S.ind = i;
%                 S.type = 'EOG';
%                 S.save = 1;
%                 D = spm_eeg_prep(S);
%                 save(D);
%                 load(D.fname)
%             elseif strcmp(D.channels(1,i).label, 'EEG063')
%                 S.ind = i;
%                 S.type = 'ECG';
%                 S.save = 1;
%                 D = spm_eeg_prep(S);
%                 save(D);
%                 load(D.fname)
%             end
%         end
%         
        
        
        %% Reference to the average, if using eeg:
        
        S=[]; S.D = D.fname;
        S.refchan = 'average';
        D = spm_eeg_reref_eeg(S);
        
                
        %% filter data in SPM8:
        % Notch filter
        S = [];
        S.D = D.fname;
        S.filter.type = 'butterworth';
        S.filter.order = 5;
        S.filter.band = 'stop';
        S.filter.PHz = [49 51];
        disp('filter');
        D = spm_eeg_filter(S);
        
        
        % Highpass filter
        S = [];
        S.D = D.fname;
        S.filter.type = 'butterworth';
        S.filter.band = 'high';
        S.filter.PHz = 1;
        S.filter.order = 5;
        S.filter.para = [];
        D = spm_eeg_filter(S);
        
        
        % Lowpass filter
        S = [];
        S.D = D.fname;
        S.filter.type = 'butterworth';
        S.filter.band = 'low';
        S.filter.PHz = 40;
        S.filter.order = 5;
        S.filter.para = [];
        D = spm_eeg_filter(S);
        
        
        %% Downsampling:
        
        S = [];
        S.D = D.fname;
        S.fsample_new = 200;
        D = spm_eeg_downsample(S);
        
               
        %% Epoching:
        
        %spm('defaults', 'eeg');
        
        S = [];
        S.pretrig = epoch(1);
        S.posttrig = epoch(2);
        S.trialdef(1).conditionlabel = 'spec_all';
        S.trialdef(1).eventvalue = [11 12 13 14]; % select the MEG/EEG trigger codes which correspond to the stimuli/response you want to epoch around
        S.trialdef(2).conditionlabel = 'free_all';
        S.trialdef(2).eventvalue = [51 52 53 54];
        S.trialdef(3).conditionlabel = 'spec_ind';
        S.trialdef(3).eventvalue = 11;
        S.trialdef(4).conditionlabel = 'spec_mid';
        S.trialdef(4).eventvalue = 12;
        S.trialdef(5).conditionlabel = 'spec_ring';
        S.trialdef(5).eventvalue = 13;
        S.trialdef(6).conditionlabel = 'spec_lit';
        S.trialdef(6).eventvalue = 14;
        S.trialdef(7).conditionlabel = 'free_ind';
        S.trialdef(7).eventvalue = 51;
        S.trialdef(8).conditionlabel = 'free_mid';
        S.trialdef(8).eventvalue = 52;
        S.trialdef(9).conditionlabel = 'free_ring';
        S.trialdef(9).eventvalue = 53;
        S.trialdef(10).conditionlabel = 'free_lit';
        S.trialdef(10).eventvalue = 54;
        
        
        for c=1:10
            S.trialdef(c).eventtype = 'STI101_up'; % look for rising signal in trigger channel for event times
        end
        
        S.reviewtrials = 0;
        S.save = 0;
        S.D = D.fname;
        S.bc = 1;
        S.inputformat = [];
        S.epochinfo.padding = 0;
        D = spm_eeg_epochs(S);
        
        efile{ses} = D.fname;
        
                
    end % of ses/block loop
      
    %% Concatenation of blocks:
    
    S=[];
    S.D = strvcat(efile);
    S.recode = 'same';
    D = spm_eeg_merge(S);
    
   
    %% Artifact rejection
    % Use thresholds to do artefact rejection. You may wish to adjust these levels
    
    S = []; S.D = D.fname;
    
   
    S.methods(1).fun = 'peak2peak';
    %S.methods(1).fun = 'threshchan';
    S.methods(1).channels = 'EOG';
    S.methods(1).settings.threshold = 200e-6;
    
    
    %    Defaults:
    S.methods(end+1).fun = 'peak2peak';
    S.methods(end).channels = 'MEG';
    S.methods(end).settings.threshold = 20e-12; %2500ft%meg_thr(ss);
    %
    S.methods(end+1).fun = 'peak2peak';
    S.methods(end).channels = 'MEGPLANAR';
    S.methods(end).settings.threshold = 200e-12; %900ft%meg_thr(ss);
    %
    S.methods(end+1).fun = 'peak2peak';
    S.methods(end).channels = 'EEG';
    S.methods(end).settings.threshold = 200e-6;
    
    D = spm_eeg_artefact(S);
    
    nbadchan(ss) = length(D.badchannels);
    nrejects(ss) = sum(D.reject);
    
    
    %% Average (robust averaging)
    
    D = condlist(D,con_labels);  % redefine condition order for weight epochs below
    D.save;
    
    preavg = D.fname;
    S=[]; S.D = preavg;
    S.robust = 1;
    S.userobust.robust.ks = 3;
    S.userobust.robust.bycondition = true;
    S.userobust.robust.savew = false;
    
    D = spm_eeg_average(S);
    
    
    %save batch_params rawfile efile nbadchan nrejects %nevents
    cd ../
end % of subjects loop
% if ParType
%     matlabpool close force CBU_Cluster
% end
return