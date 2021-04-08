
% NB: THIS FILE IS NOT FINISHED AND PROBABLY NEVER WILL BE :)



subjects_and_parameters;

outpathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/';
pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/';
ft_dir = [outpathstem 'fieldtrip/'];
filename = 'wrmtf*.mat';

%% Make files of data for fieldtrip stats functions

modality = {'MEGPLANAR'};

if ~exist(ft_dir,'dir')
    mkdir(ft_dir);
else
    delete([ft_dir '*.mat']);
end
    
for s=1:length(subjects)
    
    file = dir([pathstem subjects{s} '/' filename]);
    D=spm_eeg_load([pathstem subjects{s} '/' file.name]);
    
    for m=1:length(modality)

        chanind = D.selectchannels(modality{m});        
        conind = D.indtrial(D.conditions);
        
        for c=1:length(conind)
            
            timelock = D.fttimelock(chanind,[],conind(c),[]);
            
            if strcmp(modality{m},'MEG') || strcmp(modality{m},'MEGPLANAR')
                timelock.powspctrm = timelock.powspctrm * 1e30;
            elseif strcmp(modality{m},'EEG')
%                 cfg = [];
%                 cfg.method = 'template';
%                 cfg.elec = D.sensors('EEG');
%                 cfg.rotate = 0;
%                 chaninds = D.meegchannels(modality{m});
%                 cfg.channel = D.chanlabels(chaninds);
%                 cfg.neighbours = ft_prepare_neighbours(cfg);
%                 timelock_tmp = timelock;
%                 timelock_tmp.dimord = 'rpt_chan_freq_time';
%                 timelock_tmp = rmfield(timelock_tmp,'powspctrm');
%                 timelock_tmp.powspctrm(1,:,:,:) = timelock.powspctrm;
%                 timelock_tmp.powspctrm(2,:,:,:) = timelock.powspctrm;               
%                 timelock_tmp = ft_channelrepair([],timelock_tmp);
%                 timelock.powspctrm = timelock_tmp(1,:,:,:);
%                               
%                 timelock.powspctrm = timelock.powspctrm * 1e12;
            end
                            
            save([ft_dir sprintf('%s_%s_subj%d.mat',modality{m},cell2mat(D.conditions(conind(c))),s)],'timelock');
            
        end
        
    end
    
    clear D
    
end


%% Run stats

peak_thresh = .05;
cluster_thresh = .05; % set to [] if not needed

modality = {'MEGPLANAR'};
contrast_name = {'Match-MisMatch', 'Clear minus Unclea'};
contrast_cons = {'Match' 'Mismatch'; '16' '4'};

file = dir([pathstem '/g' filename]);
D=spm_eeg_load([pathstem '/' file.name]);

for m=1:length(modality)
    
    for cn=1:size(contrast_cons,1)
        
        filenames = {}; design = [];
        count = 0;
        for cd=1:size(contrast_cons,2)
            
            for s=1:length(subjects)
                
                count = count + 1;
                
                filenames{count} = [ft_dir sprintf('%s_%s_subj%d.mat',modality{m},contrast_cons{cn,cd},s)];
                design(1,count) = cd;
                design(2,count) = s;
                
            end
            
        end
        
        cfg = [];
        if cluster_thresh
            switch modality{m}
                case 'MEG'
                    cfg.grad = D.sensors('MEG');
                    chaninds = D.meegchannels('MEG');
                    cfg.channel = D.chanlabels(chaninds);                 
                case 'MEGPLANAR'
                    cfg.grad = D.sensors('MEG');
                    chaninds = spm_eeg_grad_pairs(D);
                    chaninds = chaninds(:,1);
                    cfg.channel = D.chanlabels(chaninds);
                case 'EEG'
                    cfg.elec = D.sensors('EEG');
                    cfg.rotate = 0;
                    chaninds = D.meegchannels('EEG');
                    cfg.channel = D.chanlabels(chaninds);
            end
            cfg.method = 'distance';
            cfg.feedback = 'no';
            cfg.neighbours = ft_prepare_neighbours(cfg);
                  
            cfg.correctm = 'cluster';
            cfg.alpha = cluster_thresh;
            cfg.clusteralpha = peak_thresh;
        else
            cfg.correctm = 'max';
            cfg.alpha = peak_thresh;
        end
        
        cfg.design = design;
        cfg.ivar = 1; % the 1st row in cfg.design contains the independent variable
        cfg.uvar = 2; % the 2nd row in cfg.design contains the subject number
        cfg.inputfile = filenames;
        %cfg.channel = {'MEG0341'};
        %cfg.avgoverchan = 'no';
        cfg.latency     = [0 1];
        cfg.avgovertime = 'no';
        %cfg.frequency = [30 90];
        cfg.frequency = [4 30];
        cfg.avgoverfreq = 'no';
        cfg.method      = 'montecarlo';
        cfg.statistic   = 'depsamplesT';
        cfg.correcttail = 'no';
        cfg.numrandomization = 500;
        %cfg.minnbchan = 2;
        
        %stat = ft_timelockstatistics(cfg);
        stat = ft_freqstatistics(cfg);
        
        save([ft_dir sprintf('stat_%s_%s_%s_pPeak%.3f_%s.mat',modality{m},cfg.statistic,contrast_name{cn},peak_thresh,cfg.correctm)],'stat');
        
    end
    
end


%% Threshold data and prepare for plotting

contrast = '8-2';

load([ft_dir 'stat_MEG_depsamplesT_' contrast '_pPeak0.05_cluster.mat']);
display_thresh = .05;

file = dir([pathstem '/g' filename]);
D=spm_eeg_load([pathstem '/' file.name]);
timelock = D.fttimelock(D.indchannel(stat.label),[],D.indtrial(contrast),[]);

pos = logical(zeros(size(stat.stat)));
neg = logical(zeros(size(stat.stat)));

if ~isempty(stat.posclusters)
    pos_cluster_pvals = [stat.posclusters(:).prob];
    pos_signif_clust = find(pos_cluster_pvals < display_thresh);
    pos = ismember(stat.posclusterslabelmat, pos_signif_clust);
    if ~isempty(pos_signif_clust)
        fprintf('\n\nFound %d significant positive clusters\n',length(pos_signif_clust));
        for i=1:length(pos_signif_clust)
            pos_current = stat.posclusterslabelmat == i;
            stat_filtered = stat.stat;
            stat_filtered(~pos_current) = NaN;
            [maxi,ind] = max(abs(stat_filtered(:)));
            [Cind Find Tind] = ind2sub(size(stat_filtered),ind);
            fprintf('\nPositive cluster %d:\n',i);
            fprintf('\nPeak data point for this cluster located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);
        end
    end
end

if ~isempty(stat.negclusters)
    neg_cluster_pvals = [stat.negclusters(:).prob];
    neg_signif_clust = find(neg_cluster_pvals < display_thresh);
    neg = ismember(stat.negclusterslabelmat, neg_signif_clust);
    if ~isempty(neg_signif_clust)
        fprintf('\n\nFound %d significant negative clusters\n',length(neg_signif_clust));
        for i=1:length(neg_signif_clust)
            neg_current = stat.negclusterslabelmat == i;
            stat_filtered = stat.stat;
            stat_filtered(~neg_current) = NaN;
            [maxi,ind] = max(abs(stat_filtered(:)));
            [Cind Find Tind] = ind2sub(size(stat_filtered),ind);
            fprintf('\nNegative cluster %d:\n',i);
            fprintf('\nPeak data point for this cluster located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);
        end
    end
end

stat.stat(~pos&~neg) = 0;
data2plot1 = stat.stat;

%%

contrast = 'M-MM';

load([ft_dir 'stat_MEG_depsamplesT_' contrast '_pPeak0.05_cluster.mat']);
display_thresh = .05;

pos = logical(zeros(size(stat.stat)));
neg = logical(zeros(size(stat.stat)));

if ~isempty(stat.posclusters)
    pos_cluster_pvals = [stat.posclusters(:).prob];
    pos_signif_clust = find(pos_cluster_pvals < display_thresh);
    pos = ismember(stat.posclusterslabelmat, pos_signif_clust);
    
    if ~isempty(pos_signif_clust)
        fprintf('\n\nFound %d significant positive clusters\n',length(pos_signif_clust));
        for i=1:length(pos_signif_clust)
            pos_current = stat.posclusterslabelmat == i;
            stat_filtered = stat.stat;
            stat_filtered(~pos_current) = NaN;
            [maxi,ind] = max(abs(stat_filtered(:)));
            [Cind Find Tind] = ind2sub(size(stat_filtered),ind);
            fprintf('\nPositive cluster %d:\n',i);
            fprintf('\nPeak data point for this cluster located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);
        end
    end
end

if ~isempty(stat.negclusters)
    neg_cluster_pvals = [stat.negclusters(:).prob];
    neg_signif_clust = find(neg_cluster_pvals < display_thresh);
    neg = ismember(stat.negclusterslabelmat, neg_signif_clust);

    if ~isempty(neg_signif_clust)
        fprintf('\n\nFound %d significant negative clusters\n',length(neg_signif_clust));
        for i=1:length(neg_signif_clust)
            neg_current = stat.negclusterslabelmat == i;
            stat_filtered = stat.stat;
            stat_filtered(~neg_current) = NaN;
            [maxi,ind] = max(abs(stat_filtered(:)));
            [Cind Find Tind] = ind2sub(size(stat_filtered),ind);
            fprintf('\nNegative cluster %d:\n',i);
            fprintf('\nPeak data point for this cluster located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);
        end
    end
end

stat.stat(~pos&~neg) = 0;
data2plot2 = stat.stat;

%%

data2plot1(~data2plot1|~data2plot2) = 0;
data2plot2(~data2plot1|~data2plot2) = 0;

data_conjunc = min(abs(data2plot1),abs(data2plot2));
[maxi,ind] = max(data_conjunc(:));
[Cind Find Tind] = ind2sub(size(data_conjunc),ind);

fprintf('\n\nPeak data point for conjunction located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);

% [maxi,ind] = max(abs(data2plot1(:)));
% [Cind Find Tind] = ind2sub(size(data2plot1),ind);
% 
% fprintf('\n\nPeak data point for cluster 1 located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);
% 
% [maxi,ind] = max(abs(data2plot2(:)));
% [Cind Find Tind] = ind2sub(size(data2plot2),ind);
% 
% fprintf('\n\nPeak data point for cluster 2 located at %s, %2.0fHz and %2.0fms\n\n',stat.label{Cind},stat.freq(Find),stat.time(Tind)*1000);


%%

data2plot = data2plot1;

%% Plot aerial view of time-frequency graphs across channels

modality = 'MEG';
display_max = [];
df = 20;

if ~isempty(pos_signif_clust) || ~isempty(neg_signif_clust)
    
    limits = [];
    if ~isempty(display_max)
        maxi = spm_invTcdf(1-display_max,df);
        limits = [-maxi maxi];
    end
    
    file = dir([pathstem '/g' filename]);
    D=spm_eeg_load([pathstem '/' file.name]);

    timelock = D.fttimelock(D.indchannel(stat.label),D.indsample(stat.time),1,D.indfrequency(stat.freq));   
    timelock.data2plot = data2plot;
    
    load([pathstem modality '_layout.mat']);
    lay = rmfield(lay,'width');
    lay = rmfield(lay,'height');
    lay.label = timelock.label;
    
    cfg = [];
    cfg.layout = lay;
    cfg.parameter = 'data2plot';
    if ~isempty(display_max)
        cfg.zlim = limits;
    else
        cfg.zlim = 'maxabs';
    end
    cfg.interactive = 'yes';
    figure; ft_multiplotTFR(cfg,timelock);
    
else
    
    fprintf('\n\nNo significant data to plot!\n\n');
    
end

%% Plot topography of time-frequency data

% modality = 'MEGPLANAR'; % MEGPLANAR Test 24-1
% channel = {'MEG2633'};
% freqRange = [90 90];
% timeRange = [880 880];
% modality = 'MEGPLANAR'; % MEGPLANAR M-MM
% channel = {'MEG0743'};
% freqRange = [40 40];
% timeRange = [660 660];
modality = 'MEGPLANAR'; % Overlap of Test 24-1 and M-MM
channel = {'MEG2642'};
freqRange = [42 42];
timeRange = [720 720];

display_max = [.001];
df = [20];

if ~isempty(pos_signif_clust) || ~isempty(neg_signif_clust)
    
    if ~isempty(display_max)
        maxi = spm_invTcdf(1-display_max,df);
        limits = [-maxi maxi];
    end
    
    file = dir([pathstem '/g' filename]);
    D=spm_eeg_load([pathstem '/' file.name]);

    timelock = D.fttimelock(D.indchannel(stat.label),D.indsample(stat.time),1,D.indfrequency(stat.freq));
    timelock.data2plot = data2plot;
    
    load([pathstem modality '_layout.mat']);
    lay = rmfield(lay,'width');
    lay = rmfield(lay,'height');
    lay.label = timelock.label;
    
    cfg = [];
    cfg.layout = lay;  
    cfg.parameter = 'data2plot';
    cfg.xlim = timeRange/1000;
    cfg.ylim = freqRange;
    if ~isempty(display_max)
        cfg.zlim = limits;
    else
        cfg.zlim = 'maxabs';
    end
    cfg.highlight = 'on';
    cfg.highlightsize  = 12;
    cfg.highlightcolor = [1 1 1];
    cfg.highlightchannel = channel;
    
    figure; ft_topoplotTFR(cfg,timelock);
    
else
    
    fprintf('\n\nNo significant data to plot!\n\n');
    
end

%% Plot time-frequency graph of data for one channel

%channel = 'MEG2633'; % MEGPLANAR Test 24-1
%channel = 'MEG0743'; % MEGPLANAR M-MM
channel = {'MEG2642'}; % Overlap of Test 24-1 and M-M

display_max = [];
df = 20;

if ~isempty(pos_signif_clust) || ~isempty(neg_signif_clust)
    
    if ~isempty(display_max)
        maxi = spm_invTcdf(1-display_max,df);
        limits = [-maxi maxi];
    end
    
    file = dir([pathstem '/g' filename]);
    D=spm_eeg_load([pathstem '/' file.name]);

    timelock = D.fttimelock(D.indchannel(channel),D.indsample(stat.time),1,D.indfrequency(stat.freq));
    timelock.data2plot = data2plot;
    
    cfg = [];
    cfg.parameter = 'data2plot';
    %cfg.channel = channel;
    if ~isempty(display_max)
        cfg.zlim = limits;
    else
        cfg.zlim = 'maxabs';
    end
    cfg.maskstyle = 'saturation';
    
    figure; ft_singleplotTFR(cfg,timelock);
    
else
    
    fprintf('\n\nNo significant data to plot!\n\n');
    
end

