%% Initialise path and subject definitions

tec_MMN_batch_init; 

%% Single subject ERP analysis (averaging over conditions)

% parameters
file2plot = 'fmcfbeMdsspm8_run1_raw_ssst.mat';
file2plotelse = 'fmcfbeMdsspm8_run1_1_raw_ssst.mat';
% file2plot = 'fmcfbMdspm8_run1_raw_ssst.mat';
modality = {'MEG' 'MEGPLANAR' 'EEG'};
plotRange = [-100 800]; % total time range to plot

for m=1:length(modality)
    
    figure; % new figure for each modality
    
    for s=1:length(subjects)
        
        % load subject average
        try
            D = spm_eeg_load([pathstem subjects{s} '/' file2plot]);
        catch
            D = spm_eeg_load([pathstem subjects{s} '/' file2plotelse]);
        end
        times = D.time*1000;
        
        % determine sample range to plot
        startSample = nearestpoint(plotRange(1),times);
        endSample = nearestpoint(plotRange(2),times);
        
        % get channels indices for specified modality
        chanind = D.meegchannels(modality{m});
        chanindbad = D.badchannels;
        if ~isempty(chanindbad) % exclude bad channels (if present)
            chanind = setdiff(chanind,chanindbad);
        end
        % get data for selected channels
        data = D(chanind,:,:);
        % average over conditions
        data = mean(data,3);
        % get rms over channels
        data = sqrt(mean(data.^2,1));
        
        % plot
        plot(times(startSample:endSample),data(startSample:endSample),'linewidth',2); hold all
        
    end
    
    set(gca,'FontSize',12,'FontWeight','Bold');
    xlabel('Time (ms)');
    legend(subjects);
    title(modality{m},'FontSize',14,'FontWeight','Bold');
    
end

%% Plot grand average ERPs for selected conditions

% parameters
file2plot = [pathstem subjects{1} '/' 'fmcfbMdspm8_run1_raw_ssst.mat'];
chanlabel = 'MEGPLANAR'; % Plot selected channels or modality (if modality, can choose to plot rms or all channels- see rms variable below)
con2plot = conditions;
styles = {'-r' '-b' '--r' '--b' '*r' '*b'};
plotRange = [-100 800]; % total time range to plot
rms = 1; % if modality has been specified above (rather than single channel), plot all channels (0) or rms (1)

% load grand average
D = spm_eeg_load(file2plot);
times = D.time * 1000;

% determine sample range to plot
startSample = nearestpoint(plotRange(1),times);
endSample = nearestpoint(plotRange(2),times);

% make figure
figure;

storedata = []; % needed for shading time windows
for c=1:length(con2plot)
   
    if sum(strcmp(chanlabel,{'MEG' 'MEGPLANAR' 'EEG'}))

        % get channels indices for specified modality
        chaninds = D.meegchannels(chanlabel);
        % get condition index
        coninds = D.pickconditions(con2plot{c});
        % get data for selected channels and current condition
        data = D(chaninds,:,coninds);
        if rms
            % get rms over channels
            data = sqrt(mean(data.^2,1));
        end
        
    else

        % get channel indices
        chaninds = D.indchannel(chanlabel);
        % get condition index
        conind = D.pickconditions(con2plot{c});
        % get data for selected channels and current condition
        data = D(chaninds,:,conind);
        
    end
    
    % specify name of dependent measure (and convert data to sensible
    % units)
    if sum(strcmp(chanlabel,'MEG')) || ~isempty(intersect(D.meegchannels('MEG'),D.indchannel(chanlabel))) % MEGMAG
        measure = 'Amplitude (fT)';
        data = data * 1e15;
    elseif sum(strcmp(chanlabel,'MEGPLANAR')) || ~isempty(intersect(D.meegchannels('MEGPLANAR'),D.indchannel(chanlabel))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        data = data * 1e15;
    elseif sum(strcmp(chanlabel,'EEG')) || ~isempty(intersect(D.meegchannels('EEG'),D.indchannel(chanlabel))) % EEG
        measure = 'Amplitude (\muV)';
        data = data * 1e6;
    end
    
    % plot
    plot(times(startSample:endSample),data(:,startSample:endSample),styles{c},'linewidth',2); hold all
    
end

% if mean across time and conditions negative, reverse y axis
if mean(mean(data)) < 0
    set(gca,'YDir','Reverse');
end
set(gca,'FontSize',12,'FontWeight','Bold');
xlabel('Time (ms)');
ylabel(measure);
legend(con2plot);

%% Plot bar graph of signal (sensor space)
% NOTE: need to alter code to exclude plotting subjects with bad channels

% specify what to plot

% all time windows
chanlabels = {'MEG1843'};
windows = [80 120];
panels = {''}; % Slowest rotating factor (or title)...
ticks = {'80-120ms'}; % ...next slowest...
leg = {'Post-Pre_1' 'Post-Pre_6' 'Post-Pre_24'}; % ...slowest (omit if not needed).
legcolours = {'r' 'b' 'c'};

% style of text
titlesize = 14;
titleweight = 'Bold';
axessize = 12;
axesweight = 'Bold';

% set max and min data points for y-axis limits
ylim = [];

data = [];
for s=1:length(subjects)
    
    file = dir([pathstem subjects{s} '/wcfm*.mat']);
    %file = dir([pathstem subjects{s} '/cfm*.mat']);
    filename = [pathstem subjects{s} '/' file.name];
    D = spm_eeg_load(filename);
    
    tmp = [];  
    for t=1:length(ticks)
        
        for l=1:length(leg)
            
            chaninds = D.indchannel(chanlabels{t});

            if size(windows,1) > 1  % extract data from specified channel, time window and condition
                dataselect = D.selectdata(chanlabels{t},windows(t,:)/1000,leg{l});
            elseif isempty(leg)
                dataselect = D.selectdata(chanlabels{t},windows/1000,ticks{t});
            else
                dataselect = D.selectdata(chanlabels{t},windows/1000,leg{l});
            end

            dataAvg = mean(dataselect); % average over time
            tmp = [tmp dataAvg]; % store data
            
        end
        
    end
      
    data = [data; tmp];
    
end

% 1) Work out number of panels and conditions 2) Determine xtick spacing so
% that xlabels are appropriately positioned
npanels = length(panels);
nticks = length(ticks);
if ~isempty(leg{1})
    nticks = nticks * length(leg);
    xspacing = (length(leg)+1)/2:length(leg):nticks;
else
    xspacing = [1:length(ticks)];
end

% Replicate color cell array if number of elements less than number of conditions per panel 
ncolours = length(legcolours);
if ncolours < nticks
    legcolours = repmat(legcolours,1,nticks/ncolours);
end

% specify name of dependent measure (and convert data to sensible units)
if ~isempty(intersect(D.meegchannels('MEG'),D.indchannel(chanlabels{1}))) % MEGMAG
    measure = 'Amplitude (fT)';
    data = data * 1e15;
elseif ~isempty(intersect(D.meegchannels('MEGPLANAR'),D.indchannel(chanlabels{1}))) % MEGPLANAR
    measure = 'Amplitude (fT/m)';
    data = data * 1e15;
elseif ~isempty(intersect(D.meegchannels('EEG'),D.indchannel(chanlabels{1}))) % EEG
    measure = 'Amplitude (\muV)';
    data = data * 1e6;
end

% remove between subject variability
if size(windows,1) == 1 % if only one time window
    means_all_conditions = nanmean(data,2);
    grand_mean = nanmean(means_all_conditions);
    adjustment_factors = grand_mean - means_all_conditions;
    adjustment_factors = repmat(adjustment_factors,1,nticks);
    data_adj = data + adjustment_factors;
else % else more than one time window,remove btwn subj variability separately for each time-window
    count = 0;
    data_adj = [];
    for t=1:length(ticks)
        tmp = [];
        for l=1:length(leg)
            count = count + 1;
            tmp(:,l) = data(:,count); 
        end
        means_all_conditions = nanmean(tmp,2);
        grand_mean = nanmean(means_all_conditions);
        adjustment_factors = grand_mean - means_all_conditions;
        adjustment_factors = repmat(adjustment_factors,1,length(leg));
        data_adj = [data_adj [tmp+adjustment_factors] ];
    end
end

% Calculate means and sems
means = mean(data_adj,1);
sems = std(data_adj,0,1)/sqrt(length(subjects));

% reshape data according to number of panels
means = reshape(means,nticks,npanels).';
sems = reshape(sems,nticks,npanels).';

figure; % start plotting...
for p=1:npanels
    
    subplot(1,npanels,p);
    
    hold on
    
    for t=1:nticks % plot bar graph
        bar(t,means(p,t),char(legcolours(t)),'LineWidth',2);
    end
    
    for t=1:nticks % add error bars
        if means(p,t) < 0
            errorhandle = errorbar(t,means(p,t),sems(p,t),0,'k','LineWidth',2);
        else
            errorhandle = errorbar(t,means(p,t),0,sems(p,t),'k','LineWidth',2);
        end
        errorbar_tick(errorhandle);
    end
    
    % Annotate
    set(gca,'FontSize',axessize,'FontWeight',axesweight);
    if ~isempty(ylim)
        set(gca,'YLim',ylim);
    end
    if mean(means(p,:)) < 0 % if mean across conditions negative, reverse y axis
        set(gca,'YDir','Reverse');
    end
    ylabel(measure);
    set(gca,'XLim',[0 nticks+1]);
    set(gca,'XTick',xspacing);
    set(gca,'XTickLabel',ticks);
    title(panels{p},'FontSize',titlesize,'FontWeight',titleweight);
    
end

if ~isempty(leg{1})
    legend(gca,leg,'Location','NorthWest'); % add legend (if appropriate)
end

hold off

%% Plot grand average ERP topographies across conditions (fieldtrip version)

% parameters

% modality = 'MEG';
% con2plot = {'Post-Pre'};
% %windows = [88 88; 380 380; 500 500; 644 644];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-5e-14 5e-14];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_test_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Post-Pre.img'};
% p = 1;
% df = [1 95];

% modality = 'MEGPLANAR';
% con2plot = {'Post-Pre'};
% %windows = [88 88; 240 240; 700 700;];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-4e-13 4e-13];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_test_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Post-Pre.img'};
% p = 1;
% df = [1 95];

% modality = 'EEG';
% con2plot = {'Post-Pre'};
% %windows = [84 84; 196 196; 380 380; 488 488];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-1.5e-6 1.5e-6];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_test_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Post-Pre.img'};
% p = 1;
% df = [1 95];

% modality = 'MEG';
% con2plot = {'Train_Match-Mismatch'};
% %windows = [504 504; 580 580; 604 604];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-7e-14 7e-14];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Matching-Mismatching.img'};
% p = 1;
% df = [1 95];

% modality = 'MEGPLANAR';
% con2plot = {'Train_Match-Mismatch'};
% windows = [312 792; 232 800;];
% highlightchannel = {};
% limits = [-.75e-12 .75e-12];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Matching-Mismatching_51_24_484.nii' 'Matching-Mismatching_-47_8_572.nii'};
% p = 1;
% df = [1 95];

modality = 'EEG';
con2plot = {'Train_Match-Mismatch'};
windows = [396 760; 208 800; 148 800;];
highlightchannel = {};
limits = [-2e-6 2e-6];
imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
imgs = {'Matching-Mismatching_60_-25_588.nii' 'Matching-Mismatching_-4_-19_644.nii' 'Matching-Mismatching_-51_-9_568.nii'};
p = 1;
df = [1 95];

% modality = 'MEG';
% con2plot = {'Train_12-3'};
% %windows = [128 128; 712 712; 788 788];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-3e-14 3e-14];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Sensory_detail.img'};
% p = 1;
% df = [2 95];

% modality = 'MEGPLANAR';
% con2plot = {'Train_12-3'};
% windows = [524 800; 232 332;];
% highlightchannel = {};
% limits = [-.75e-12 .75e-12];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Sensory_detail_26_18_748.nii' 'Sensory_detail_-47_8_256.nii'};
% p = 1;
% df = [2 95];

% modality = 'EEG';
% con2plot = {'Train_12-3'};
% windows = [604 744; 556 632; 548 752; 108 204;];
% highlightchannel = {};
% limits = [-2e-6 2e-6];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Sensory_detail_21_50_676.nii' 'Sensory_detail_30_-46_612.nii' 'Sensory_detail_55_18_636.nii' 'Sensory_detail_-4_-25_168.nii'};
% p = 1;
% df = [2 95];

nconditions = length(con2plot);
nwindows = size(windows,1);

% get SPM data and convert into fieldtrip format
D = spm_eeg_load([pathstem 'gwpcfmcfbMdspm8_01_preTest_raw_ssst.mat']); % load grand average
data_ft = D.fttimelock; % convert to fieldtrip format
data_ft.avg = data_ft.trial;
data_ft.time = data_ft.time*1000;

% setup channel layout for ft_topoplotER
cfg = [];
switch modality
    case 'MEG'
        chaninds = D.meegchannels('MEG');
        cfg.layout.pos = D.coor2D(chaninds)';
        cfg.layout.label = D.chanlabels(chaninds);
    case 'MEGPLANAR'
        chaninds = spm_eeg_grad_pairs(D);
        chaninds = chaninds(:,1);
        cfg.layout.pos = D.coor2D(chaninds)';
        cfg.layout.label = D.chanlabels(chaninds);
    case 'EEG'
        chaninds = D.meegchannels('EEG');
        cfg.layout.pos = D.coor2D(chaninds)';
        cfg.layout.label = D.chanlabels(chaninds);
end

% topography appearance
cfg.marker = 'off';
%cfg.comment = 'no';

% topography limits
if isempty(limits)
    cfg.zlim = 'maxabs';
else % else use manually set value
    cfg.zlim = limits;
end

figure; count = 0;
for c=1:nconditions
    
    for w=1:nwindows
        
        count = count + 1;
        subplot(nconditions,nwindows,count);
        
        cfg.xlim = windows(w,:);
        cfg.trials = D.pickconditions(con2plot{c});
        if isempty(cfg.trials)
            error('Error locating condition. Check spelling or try different MEEG file');
        end
  
        if ~isempty(highlightchannel)
            cfg.highlight = 'on';
            cfg.highlightchannel = highlightchannel{w};
            cfg.highlightsize = 9;
            cfg.highlightcolor = [1 1 1];
            cfg.highlightsymbol = 'o';
        else
            cfg.highlight = 'off';
            cfg.highlightchannel = [];
            cfg.highlightsize = [];
            cfg.highlightcolor = [];
            cfg.highlightsymbol = [];
        end
        
        if ~isempty(imgdir)
            statsdir = [imgdir modality '/'];
            V = spm_vol([statsdir imgs{count}]);
            data_img = spm_read_vols(V);
            startsample = nearestpoint(windows(w,1),data_ft.time);
            endsample = nearestpoint(windows(w,2),data_ft.time);
            %data_img = nanmean(data_img(:,:,startsample:endsample),3);
            if ndims(data_img) > 2 % if image has time dimension, calculate maximum intensity projection over time
                startsample = nearestpoint(windows(w,1),data_ft.time);
                endsample = nearestpoint(windows(w,2),data_ft.time);
                data_img = max(data_img(:,:,startsample:endsample),[],3);
            end
            [Cel, Cind] = spm_eeg_locate_channels(D, size(data_img,1), 1);
            [Cind Cind_ind] = intersect(Cind,D.meegchannels(modality));
            Cel = Cel(Cind_ind,:);
            
            load([statsdir 'SPM.mat']);
            if p < 1
                thresh = spm_uc_RF(p,df,'F',SPM.xVol.R,1);
            else
                thresh = 0;
            end
            [x y] = find(data_img>thresh);
            threshlabels = {};
            for i=1:length(x)
                [discard1 Cel_ind discard2] = spm_XYZreg('NearestXYZ',[x(i) y(i) 1],[Cel'; ones(1,size(Cel))]);
                threshlabels = [D.chanlabels(Cind(Cel_ind)); threshlabels]; 
            end
            threshlabels = unique(threshlabels);

            cfg.highlight = {cfg.highlight 'on'};
            cfg.highlightchannel = {cfg.highlightchannel threshlabels};
            cfg.highlightsize = {cfg.highlightsize 6};
            cfg.highlightcolor = {cfg.highlightcolor [0 0 0]};
            cfg.highlightsymbol = {cfg.highlightsymbol  '.'};
        end
        
        ft_topoplotER(cfg,data_ft);
        
    end
    
end

%% Display image source estimates over cortical mesh

% M-MM
% imgs = {     
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0001.img';
%        };
% 
% imgs2 = {     
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0002.img';
%        };
   
% % 12-3ch
% imgs = {     
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0001.img';
%        };
% 
% imgs2 = {     
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0002.img';
%        };

% Positive
imgs = {     
        '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t232_332_f1_40*_ttest/Source/spmT_0001.img';
        '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t148_232_f1_40*_ttest/Source/spmT_0001.img';
       };
   
% Negative   
% imgs = {
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t108_204_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t232_800_f1_40*_ttest/Source/spmT_0002.img';
%       };

%cmap = 'hot';
%cmap2 = load('/imaging/es03/P3E1/colormap_black-blue-white.mat');
%cmap2 = cmap2.cmap;
cmap = colormap('jet');
cmap = cmap(end/2+1:end,:); % for positive
%cmap = cmap(end/2:-1:1,:); % for negative

%df = [1 100];
df = [1 20];
type = 't';
p = [0.05 0.001];
symmetrical = 0;

cfg.inflate = 5;
cfg.plots = [1 2];

for i=1:length(imgs)
    
    if ~isempty(p)
        if strcmp(type,'t')
            mini = spm_invTcdf(1-abs(p(1)),df);
            mini = mini(2);
            maxi = spm_invTcdf(1-abs(p(2)),df);
            maxi = maxi(2);
        elseif strcmp(type,'F')
            mini = spm_invFcdf(1-abs(p(1)),df);
            maxi = spm_invFcdf(1-abs(p(2)),df);
        end
        
        if p(1)>0
            cfg.colorscale = [mini maxi];
            cfg.colorscale2 = [mini maxi];
        else
            cfg.colorscale = [-mini maxi];
            cfg.colorscale2 = [mini maxi];
        end
    elseif symmetrical    
        cfg.colorscale = 'symmetrical';
    else
        cfg.colorscale = [];
    end
    
    jp_spm8_surfacerender2_version_es(imgs{i},cmap,cfg);
    %jp_spm8_surfacerender2_version_es(imgs{i},cmap,cfg,imgs2{i},cmap2);
    
end

