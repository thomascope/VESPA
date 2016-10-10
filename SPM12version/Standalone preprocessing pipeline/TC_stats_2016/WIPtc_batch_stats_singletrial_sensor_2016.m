%Do some evoked stats on the sensor of maximal response for both everyone and
%controls separately in different time windows.

%% Initialise path and subject definitions

subjects_and_parameters

%% Extract sensor data from specified time-windows

% time windows of imaging data
windows = {
          %[90 130]; 
          %[180 240];
          %[270 420];
          [450 700];
          % [750 900]
          };

      %Channel order: MEG overall - control - patient, Planar overall -
      %control - patient, EEG posterior overall, anterior overall -
      %posterior control, anterior control - patient (only anterior)
channels = {'MEG0211' 'MEG0211' 'MEG0131' 'MEG0132' 'MEG0243' 'MEG0132' 'EEG057' 'EEG019' 'EEG046' 'EEG019' 'EEG005'};
      
      % Sohoglu channels:
%channels = {'MEG1221'};
%channels = {'MEG0341' 'MEG1221' 'MEG1721' 'MEG0243' 'EEG020' 'EEG046' 'EEG052' 'EEG055' 'EEG004' 'EEG009'};
%channels = {'MEG0121' 'MEG0131' 'MEG0141' 'MEG0211' 'MEG0221' 'MEG0311' ...
%'MEG0321' 'MEG0331' 'MEG0341' 'MEG0511' 'MEG0541'}; % MEG left frontal 450-700ms p<.05
%channels = {'MEG0121' 'MEG0131' 'MEG0211' 'MEG0221' 'MEG0311' 'MEG0321' 'MEG0341'}; % % MEG left frontal 450-700ms p<.001
%channels = {'MEG0132' 'MEG0143' 'MEG0213' 'MEG0222' 'MEG0232' 'MEG0243' 'MEG0322' 'MEG1512' 'MEG1522' 'MEG1543' 'MEG1613' 'MEG1622' 'MEG1813'}; % MEGPLANAR left frontal 450-700ms p<.05
%channels = {'MEG0132' 'MEG0143' 'MEG0213' 'MEG0222' 'MEG0232' 'MEG0243' 'MEG1512'}; % MEGPLANAR left frontal p<.001
  
data_imaging = {};
for s=1:length(subjects)
    
    file = dir([pathstem subjects{s} '/b*.mat']);
    filename = [pathstem subjects{s} '/' file.name];
    D = spm_eeg_load(filename);
    
    for win=1:size(windows,1)
        
        for con=1:length(conditions)
            
            for ch=1:length(channels)
                         
                ind = D.pickconditions(conditions{con});
                startSample = nearestpoint(windows{win}(1)/1000,D.time);
                endSample = nearestpoint(windows{win}(2)/1000,D.time);
                
                chanind = D.indchannel(channels{ch});
                planarind = spm_eeg_grad_pairs(D);
                [matchind discard] = find(planarind == chanind);
                if ~isempty(matchind)
                    chanind = planarind(matchind,:);
                end
            
                for trl=1:length(ind)
                    
                    tmp = mean(D(chanind,startSample:endSample,ind(trl)),2);
                    if length(chanind)==2
                        tmp = es_combineplanar(tmp);
                    end
                    data_imaging{s}(win,con,ch,trl) = tmp;

                end
                
            end
            
        end
        
    end
    
end

% for s=1:length(subjects) % for each subject, average over channels
%     data_imaging{s} = mean(data_imaging{s},3);
% end
% channels = {'Averaged channels'};

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
            
            ind = D.pickconditions(conditions{con});
            
            for trl=1:length(ind)
                
                count = count + 1;
                data_behav{s}(count,con) = D.events_custom(ind(trl)).rating;
                
            end
            
        end
        
    end
        
end

%% Determine distribution parameters

results_all = {};
for ch=1:length(channels)

%ch = 1; % select one sensor (comment out this line if running analysis for several sensors)
    
cutoff = [];
for s=1:length(subjects)
    for win=1:size(windows,1)
        data_imaging_tmp = [];
        for con=1:length(conditions)
            data_imaging_tmp = [data_imaging_tmp; squeeze(data_imaging{s}(win,con,ch,:))];
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
            data_imaging_tmp = squeeze(data_imaging{s}(win,con,ch,:));
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
%             if win==4 && (con==4 || con==5 || con==6)
%                 subplot(1,3,con-3);
%                 scatter(data_behav_tmp,data_imaging_tmp,15,'filled'); hold all
%                 x = 1:8;
%                 y = x*b(2) + b(1);
%                 plot(x,y,'LineWidth',2,'Color',ColorSet(s,:)); hold all
%                 set(gca,'xtick',[1:8]);
%                 xlim([0 9]);
%             end
        end
    end
end

%data2anova = r_corr_all;
data2anova = beta_all;

%% t-test against zero

t_ttest_zero = [];
df_ttest_zero = [];
p_ttest_zero = [];
for win=1:size(windows,1)
    for con=4:6%1:length(conditions)
        [h p ci stats] = ttest(beta_all(:,win,con));
        t_ttest_zero(con-3,win) = stats.tstat;
        df_ttest_zero(con-3,win) = stats.df;
        p_ttest_zero(con-3,win) = p;
    end
end

%% Compute contrast and t-test for each time-window

%weights = [-1/3 -1/3 -1/3 0 0 0 1/3 1/3 1/3]; % 8ch>2ch
%weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N)
weights = [0 0 0 1 -0.5 -0.5 0 0 0]; % M-(MM+N) 4 bands only
%weights = [0 0 0 1 -1 0 0 0 0]; % M-MM 4 bands only
%weights = [0 0 0 1 0 -1 0 0 0]; % M-N 4 bands only

t_ttest = [];
df_ttest = [];
p_ttest = [];
data_contrast = [];
for win=1:size(windows,1)
     
    tmp = [];
    for wt=1:size(weights,1)
        data_contrast(:,win) = sum(squeeze(data2anova(:,win,:)) .* repmat(weights(wt,:),length(subjects),1),2);
        [h p ci stats] = ttest(data_contrast(:,win));
        t_ttest(win) = stats.tstat;
        df_ttest(win) = stats.df;
        p_ttest(win) = p;
    end
    
end

%% Collate results

results_all{1}{ch,1} = channels{ch};
results_all{2}(ch,:) = reshape(p_ttest_zero,1,size(p_ttest_zero,1)*size(p_ttest_zero,2));
results_all{3}(ch,:) = p_ttest;


end

%% analysis based on binning of clarity ratings

win = 4;

%figure;
for con=4:6

    subplot(1,3,con-3);
    
    data_behav_tmp = squeeze(data_behav_all(:,win,con,:));
    data_imaging_tmp = squeeze(data_imaging_all(:,win,con,:));
    
    data_imaging_grouped = zeros(length(subjects),8,100);
    for s=1:length(subjects)
        for r=1:8
            ind = find(data_behav_tmp(s,:)==r);
            data_imaging_grouped(s,r,1:length(ind)) = data_imaging_tmp(s,ind);
        end
    end
    
    data_imaging_grouped(data_imaging_grouped==0)=NaN;
    
    data_imaging_grouped = squeeze(nanmean(data_imaging_grouped,3));
    
    %data_imaging_grouped_means = nanmean(data_imaging_grouped,1);
    %data_imaging_grouped_sems = nanstd(data_imaging_grouped,1)/sqrt(size(data_imaging_grouped,1));
    %data_imaging_grouped_means = rot90(data_imaging_grouped_means,3);
    %data_imaging_grouped_sems = rot90(data_imaging_grouped_sems,3);
    
    %b = regress(data_imaging_grouped_means,[ones(8,1) [1:8]']);
    %x = [1:8]';
    %y = x*b(2) + b(1);
    
    for s=1:length(subjects)
        
        scatter([1:8],data_imaging_grouped(s,:),20,ColorSet(s,:),'Filled'); hold all
        %plot(x,y,'LineWidth',2); hold all
        
    end
    
end

%% Plot graph

ticks = {'Matching' 'Mismatching' 'Neutral'};
legcolours = {'b' 'r' 'c'};

data2plot = squeeze(data2anova(:,1,4:6));
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

%% Compute contrast and ANOVA across time-windows
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