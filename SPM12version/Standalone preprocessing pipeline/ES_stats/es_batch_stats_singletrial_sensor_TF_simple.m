%% Initialise path and subject definitions

es_batch_init_TF;

%% Extract sensor data from specified time-windows

% time windows of imaging data
windows = {
          [800 1000];
          [400 1000];
          [200 450];
          };
freqRange = {
            [5 5];
            [10 10];
            [18 18];
            };

channels = {
%            {'MEG1723' 'MEG1643' 'MEG1633' 'MEG1843' 'MEG1523' 'MEG1613' 'MEG1623' 'MEG1813' 'MEG1823' 'MEG1513' 'MEG0243' 'MEG0233' 'MEG0443' 'MEG0433' 'MEG0133' 'MEG0213' 'MEG0223' 'MEG0413' 'MEG0423' 'MEG0123' 'MEG0343'} % MEGPLANAR left
%            {'MEG1813' 'MEG1623' 'MEG1613' 'MEG1513' 'MEG0243' 'MEG0232' 'MEG0443' 'MEG1643' 'MEG1633' 'MEG1843' 'MEG2013'} % MEGPLANAR left
%            {'MEG0233' 'MEG0243' 'MEG0213' 'MEG0223' 'MEG0413' 'MEG0443' 'MEG1623' 'MEG1813'} % MEGPLANAR left
            {'MEG2213' 'MEG1133' 'MEG1113' 'MEG1123' 'MEG1343' 'MEG1333' 'MEG1323'} % MEGPLANAR right
            {'MEG1133' 'MEG1343' 'MEG1143' 'MEG2213' 'MEG2223' 'MEG2413'} % MEGPLANAR right
            {'MEG1113' 'MEG1143' 'MEG1123' 'MEG1133'} % MEGPLANAR right 
           };
planar = 1;
  
data_imaging = {};
for s=1:length(subjects)
    
    for win=1:size(windows,1)
        
        if freqRange{win}(1) <= 7
            file = dir(['/imaging/es03/P3E1/preprocess4_TF_4_30Hz_MEGPLANAR/' subjects{s} '/tf*.mat']);
            filename = ['/imaging/es03/P3E1/preprocess4_TF_4_30Hz_MEGPLANAR/' subjects{s} '/' file.name];
            D = spm_eeg_load(filename);
        else
            file = dir(['/imaging/es03/P3E1/preprocess4_TF_4_90Hz_MEGPLANAR/' subjects{s} '/tf*.mat']);
            filename = ['/imaging/es03/P3E1/preprocess4_TF_4_90Hz_MEGPLANAR/' subjects{s} '/' file.name];
            D = spm_eeg_load(filename);
        end
        
        for con=1:length(conditions)
            
            ind = D.pickconditions(conditions{con}); % automatically excludes bad trials
            
            startSample = nearestpoint(windows{win}(1)/1000,D.time);
            endSample = nearestpoint(windows{win}(2)/1000,D.time);
            startFreq= nearestpoint(freqRange{win}(1),D.frequencies);
            endFreq = nearestpoint(freqRange{win}(2),D.frequencies);
            
            for ch=1:length(channels{win})
                
                chanind = D.indchannel(channels{win}(ch));
                if planar
                    planarind = spm_eeg_grad_pairs(D);
                    [matchind discard] = find(planarind == chanind); % find matching row
                    chanind = planarind(matchind,:);
                end
                   
                for trl=1:length(ind)
                    
                    %chanind = D.meegchannels('MEGPLANAR');
                    tmp = mean(D(chanind,startFreq:endFreq,startSample:endSample,ind(trl)),3); % average over time
                    tmp = mean(tmp,2); % average over frequency
                    %tmp = mean(tmp,1); % average over channels
                    tmp = squeeze(tmp);
                    if planar
                        tmp = es_combineplanar(tmp);
                    end
                    data_imaging{s}(win,con,ch,trl) = tmp;
                    
                end
                
            end
            
        end
        
    end
    
end

for s=1:length(subjects) % for each subject, average over channels
    data_imaging{s} = squeeze(mean(data_imaging{s},3));
end

%% Extract behavioural data (for correlating with imaging data)

% need to get this from SPM MEEG files (which has an events_custom field where I've
% stored behavioral data

filestr = 'spm8*.mat'; % need to use unmerged files as merged files only retained event info for first block

data_behav = {};
for s=1:length(subjects)
    
    files = dir([pathstem subjects{s} '/' filestr]);
    
    for con=1:length(conditions)
        
        count = 0;
        for f=1:length(files)
            
            D = spm_eeg_load([pathstem subjects{s} '/' files(f).name]);
            
            ind = D.pickconditions(conditions{con}); % automatically excludes bad trials
            
            for trl=1:length(ind)
                
                count = count + 1;
                data_behav{s}(count,con) = D.events_custom(ind(trl)).rating;
                
            end
            
        end
        
    end
        
end

%% Determine distribution parameters

cutoff = [];
for s=1:length(subjects)
    for win=1:size(windows,1)
        data_imaging_tmp = [];
        for con=1:length(conditions)
            data_imaging_tmp = [data_imaging_tmp; squeeze(data_imaging{s}(win,con,:))];
        end
        data_imaging_tmp(data_imaging_tmp==0) = []; % need to remove empty data points since conditions have non-equal numbers of trials (due to artefact removal)
        
        % get distribution mean and std
        mean_tmp = mean(data_imaging_tmp(:,1));
        std_tmp = std(data_imaging_tmp(:,1),1,1);
        cutoff(s,win,1) = mean_tmp + std_tmp*3;
        cutoff(s,win,2) = mean_tmp - std_tmp*3;
    end
end

%% Correlation between sensor-behaviour

%figure;
ColorSet = varycolor(length(subjects));

r_corr_all = [];
p_corr_all = [];
beta_all = [];
lines_all = [];
data_imaging_all = zeros(length(subjects),size(windows,1),length(conditions),100); data_imaging_all(:,:,:,:) = NaN;
data_behav_all = zeros(length(subjects),size(windows,1),length(conditions),100); data_behav_all(:,:,:,:) = NaN;
for s=1:length(subjects)
    %figure;
    for win=1:size(windows,1)
        for con=1:length(conditions)
            data_imaging_tmp = squeeze(data_imaging{s}(win,con,:));
            data_imaging_tmp(data_imaging_tmp==0) = NaN; % need to NaN data points since conditions have non-equal numbers of trials (due to artefact removal)
            data_imaging_tmp( data_imaging_tmp > cutoff(s,win,1) ) = NaN;
            data_imaging_tmp( data_imaging_tmp < cutoff(s,win,2) ) = NaN;
            data_behav_tmp = data_behav{s}(:,con);
            data_behav_tmp(data_behav_tmp==0) = NaN;
            data2correlate = [data_imaging_tmp data_behav_tmp];
            data_imaging_all(s,win,con,1:length(data_imaging_tmp)) = data_imaging_tmp;
            data_behav_all(s,win,con,1:length(data_behav_tmp)) = data_behav_tmp;
            
            % correlation coefficient (pearsons r);
            [r_corr p_corr] = corr(data2correlate,'rows','complete');
            r_corr_all(s,win,con) = r_corr(1,2);
            p_corr_all(s,win,con) = p_corr(1,2);
            %r_corr_all(s,win,con) = atanh(r_corr_all(s,win,con)); % fisher transform
            %r_corr_all(s,win,con) =
            %r_corr_all(s,win,con)/inv(sqrt(size(data2correlate,1)-3)); % convert into z-score
            
            % beta coefficient
            b = regress(data_imaging_tmp,[ones(size(data_behav_tmp,1),1) data_behav_tmp]);
            beta_all(s,win,con) = b(2);
            
            x = 1:8;
            y = x*b(2) + b(1);
            lines_all(s,win,con,:) = y;
            
            % plot scatter graph
            %             if con==4
            %                 subplot(1,2,con-3);
            %                 scatter(data_behav_tmp,data_imaging_tmp,15,'filled'); hold all
            %
            %                 %x = 1:8;
            %                 %y = x*b(2) + b(1);
            %                 %plot(x,y,'LineWidth',2,'Color',ColorSet(s,:)); hold all
            %                 %set(gca,'xtick',[1:8]);
            %                 %xlim([0 9]);
            %             end
        end
    end
end

%data2anova = r_corr_all;
data2anova = beta_all;

%% t-test against zero

% % 4 bands only
% t_ttest_zero = [];
% df_ttest_zero = [];
% p_ttest_zero = [];
% for win=1:size(windows,1)
%     for con=4:6%length(conditions)
%         [h p ci stats] = ttest(beta_all(:,win,con));
%         t_ttest_zero(con-3,win) = stats.tstat;
%         df_ttest_zero(con-3,win) = stats.df;
%         p_ttest_zero(con-3,win) = p;
%     end
% end

% averaged over bands
tmp = [];
tmp(:,:,1) = mean(beta_all(:,:,[1 4 7]),3); % average over 2 channels
tmp(:,:,2) = mean(beta_all(:,:,[2 5 8]),3); % average over 4 channels
tmp(:,:,3) = mean(beta_all(:,:,[3 6 9]),3); % average over 8 channels
beta_all = tmp;

t_ttest_zero = [];
df_ttest_zero = [];
p_ttest_zero = [];
for win=1:size(windows,1)
    for con=1:3
        [h p ci stats] = ttest(beta_all(:,win,con));
        t_ttest_zero(con,win) = stats.tstat;
        df_ttest_zero(con,win) = stats.df;
        p_ttest_zero(con,win) = p;
    end
end

%% Compute contrast and t-test for each time-window

%weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N), 4 bands only
weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N), averaged over bands
%weights = [-1/3 -1/3 -1/3 0 0 0 1/3 1/3 1/3]; % 8-2ch

t_ttest = [];
df_ttest = [];
p_ttest = [];
data_contrast = [];
for win=1:size(windows,1)
    
    tmp = [];
    for wt=1:size(weights,1)
        data_contrast(:,win) = sum(squeeze(data2anova(:,win,:)).* repmat(weights(wt,:),length(subjects),1),2);
        [h p ci stats] = ttest(data_contrast(:,win));
        t_ttest(win) = stats.tstat;
        df_ttest(win) = stats.df;
        p_ttest(win) = p;
    end
    
end

%% Plot graph of correlations

ticks = {'Matching' 'Mismatching' 'Neutral'};
legcolours = {'b' 'r' 'c'};

for win=1:length(windows)
    
    data2plot = squeeze(data2anova(:,win,4:6));
    data2plot_adj = es_removeBetween(data2plot);
    
    means = mean(data2plot_adj,1);
    sems = std(data2plot_adj,0,1)/sqrt(size(data2plot_adj,1));
    
    figure; hold all
    for t=1:length(ticks)
        bar(t,means(t),char(legcolours(t)),'LineWidth',2);
    end
    for t=1:length(ticks)
        if means(t) < 0
            errorhandle = errorbar(t,means(t),sems(t),0,'k','LineWidth',2);
        else
            errorhandle = errorbar(t,means(t),0,sems(t),'k','LineWidth',2);
        end
        errorbar_tick(errorhandle);
    end
    set(gca,'xtick',[1:3]);
    set(gca,'xticklabel',ticks);
    set(gca,'xlim',[0 4]);
    ylabel('fT/unit of clarity');
    
end

%% Compute contrast of correlations and ANOVA across time-windows
% Also does some plotting

weights = [
          %-1/3 -1/3 -1/3 0 0 0 1/3 1/3 1/3; % 8ch>2ch
          %1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6; % M-(MM+N)
          0 0 0 1 -0.5 -0.5 0 0 0; % M-(MM+N) 4 bands only
          ];  

count = 0;
data_contrast = [];
for win=1:size(windows,1)
     
    for wt=1:size(weights,1)
        
        count = count + 1;
        data_contrast(:,count) = sum(squeeze(data2anova(:,win,:)).* repmat(weights(wt,:),length(subjects),1),2);
        
    end
 
end

if size(weights,1)>1
    [efs,F,cdfs,p,eps,dfs,b,y2,sig] = repanova(data_contrast,[size(windows,1) size(weights,1)]);
    %[efs,F,cdfs,p,eps,dfs,b,y2,sig] = repanova(data_contrast,[2 size(weights,1)]);
else
    [efs,F,cdfs,p,eps,dfs,b,y2,sig] = repanova(data_contrast,size(windows,1));
    %[efs,F,cdfs,p,eps,dfs,b,y2,sig] = repanova(data_contrast,2);
end

% Plot means and sems of correlation coefficients

%data_contrast_adj = es_removeBetween(data_contrast);
data_contrast_adj = data_contrast;

data_contrast_means = [];
data_contrast_sems = [];
count = 0;
for win=1:size(windows,1)
     
    for wt=1:size(weights,1)
        
        count = count + 1;
        data_contrast_means(win,wt) = mean(data_contrast_adj(:,count),1);
        data_contrast_sems(win,wt) = std(data_contrast_adj(:,count),0,1)/sqrt(size(data_contrast_adj(:,count),1));
        
    end
 
end

colors = {'r' 'b'};

figure;
for wt=1:size(weights,1)
    errorbar(1:size(windows,1),data_contrast_means(:,wt),data_contrast_sems(:,wt),colors{wt},'linewidth',2); hold on   
end

%legend({'From sensory detail' 'From prior knowledge'});
%set(gca,'xtick',1:size(windows,1));
%set(gca,'xticklabel',{'90-130ms' '180-240ms' '270-420ms' '450-700ms'});
ylabel('Change in behaviour-neural correlation');

 %% analysis based on binning of clarity ratings
  
con_ind = [1:9]; % to select subset of conditions
 
medianData = [];

for s=1:length(subjects)
    count = 1;
    for win=1:length(windows)
        for con=con_ind
            data4median = squeeze(data_imaging{s}(win,con,:)); % get data from current condition
            data4median(data4median==0) = [];
            mid = median(reshape(data4median,1,size(data4median,1)*size(data4median,2))); % calculate median for current condition
            data_imaging_tmp = squeeze(data_imaging{s}(win,con,:)); % get data for current condition
            data_imaging_tmp(data_imaging_tmp==0) = [];
            ind_low = find(data_imaging_tmp<mid); % find indices for current data below median
            ind_high = find(data_imaging_tmp>mid); % find indices for current data above median
            % compute average clarity over low and high activity
            % data and store data
            data_behav_tmp = data_behav{s}(:,con);
            data_behav_tmp(data_behav_tmp==0) = [];
            medianData(s,count) = mean(data_behav_tmp(ind_high)) - mean(data_behav_tmp(ind_low));
            medianData(s,count) = mean(data_behav_tmp(ind_low));
            medianData(s,count+1) = mean(data_behav_tmp(ind_high));
            %count = count + 1;
            count = count + 2;
        end
    end
end
 