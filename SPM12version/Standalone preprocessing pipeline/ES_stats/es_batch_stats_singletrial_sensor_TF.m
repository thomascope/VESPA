%% Initialise path and subject definitions

es_batch_init_TF;

%% Extract sensor data from specified time-windows

% time windows of imaging data
windows = {
          [400 1000];
          [400 1000];
          [200 450];
          };
freqRange = {
            [5 5];
            [10 10];
            [18 18];
            };

channels = {'MEG0242' 'MEG2012' 'MEG0232'}; % MEGPLANAR
planar = 1;
  
data_imaging = {};
for s=1:length(subjects)
    
    file = dir([pathstem subjects{s} '/tf*.mat']);
    filename = [pathstem subjects{s} '/' file.name];
    D = spm_eeg_load(filename);
    
    for win=1:size(windows,1)
        
        for fq=1:size(freqRange,1)          
            
            for con=1:length(conditions)
                
                for ch=1:length(channels)
                    
                    ind = D.pickconditions(conditions{con}); % automatically excludes bad trials
                    
                    startSample = nearestpoint(windows{win}(1)/1000,D.time);
                    endSample = nearestpoint(windows{win}(2)/1000,D.time);
                    startFreq= nearestpoint(freqRange{fq}(1),D.frequencies);
                    endFreq = nearestpoint(freqRange{fq}(2),D.frequencies);
                    
                    chanind = D.indchannel(channels{ch});
                    if planar
                        planarind = spm_eeg_grad_pairs(D);
                        [matchind discard] = find(planarind == chanind);
                        chanind = planarind(matchind,:);
                    end
                    
                    for trl=1:length(ind)
                        
                        tmp = mean(D(chanind,startFreq:endFreq,startSample:endSample,ind(trl)),3); % average over time
                        tmp = mean(tmp,2); % average over frequency
                        tmp = squeeze(tmp);
                        if planar
                            tmp = es_combineplanar(tmp);
                        end
                        data_imaging{s}(win,fq,con,ch,trl) = tmp;
                        
                    end
                    
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
            
            ind = D.pickconditions(conditions{con}); % automatically excludes bad trials
            
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
    
    ch = 2; % select one sensor (comment out this line if running analysis for several sensors)
    fq = 2; % select one frequency range
    
    cutoff = [];
    for s=1:length(subjects)
        for win=1:size(windows,1)
            data_imaging_tmp = [];
            for con=1:length(conditions)
                data_imaging_tmp = [data_imaging_tmp; squeeze(data_imaging{s}(win,fq,con,ch,:))];
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
                data_imaging_tmp = squeeze(data_imaging{s}(win,fq,con,ch,:));
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
    
    % 4 bands only
    t_ttest_zero = [];
    df_ttest_zero = [];
    p_ttest_zero = [];
    for win=1:size(windows,1)
        for con=4:6%length(conditions)
            [h p ci stats] = ttest(beta_all(:,win,con));
            t_ttest_zero(con-3,win) = stats.tstat;
            df_ttest_zero(con-3,win) = stats.df;
            p_ttest_zero(con-3,win) = p;
        end
    end

%     % averaged over bands
%     tmp = [];
%     tmp(:,:,1) = mean(beta_all(:,:,[1 4 7]),3); % average over 2 channels
%     tmp(:,:,2) = mean(beta_all(:,:,[2 5 8]),3); % average over 4 channels
%     tmp(:,:,3) = mean(beta_all(:,:,[3 6 9]),3); % average over 8 channels
%     beta_all = tmp;
%     
%     t_ttest_zero = [];
%     df_ttest_zero = [];
%     p_ttest_zero = [];
%     for win=1:size(windows,1)
%         for con=1:3
%             [h p ci stats] = ttest(beta_all(:,win,con));
%             t_ttest_zero(con,win) = stats.tstat;
%             df_ttest_zero(con,win) = stats.df;
%             p_ttest_zero(con,win) = p;
%         end
%     end
    
    %% Compute contrast and t-test for each time-window
    
    weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N), 4 bands only
    %weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N), averaged over bands
    
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
    
    %% Collate results
    
    results_all{1}{ch,1} = channels{ch};
    results_all{2}(ch,:) = reshape(p_ttest_zero,1,size(p_ttest_zero,1)*size(p_ttest_zero,2));
    results_all{3}(ch,:) = p_ttest;
    
    
end % end of channel loop

%% Plot graph of correlations

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
 
 medianData = [];
 
 for con=1:length(conditions)
     for ch=1:length(channels) 
         for win=1:length(windows)  
             for fq=1:length(freqRange)  
                 for s=1:length(subjects) 
                     data4median = squeeze(data_imaging{s}(win,fq,con,ch,:)); % get data from all conditions
                     data4median(data4median==0) = [];
                     mid = median(reshape(data4median,1,size(data4median,1)*size(data4median,2))); % calculate median across all conditions
                     data_imaging_tmp = squeeze(data_imaging{s}(win,fq,con,ch,:)); % get data for current condition
                     data_imaging_tmp(data_imaging_tmp==0) = [];
                     ind_low = find(data_imaging_tmp<mid); % find indices for current data below median
                     ind_high = find(data_imaging_tmp>mid); % find indices for current data above median
                     % compute average clarity over low and high activity
                     % data and take the difference
                     data_behav_tmp = data_behav{s}(:,con);
                     data_behav_tmp(data_behav_tmp==0) = [];
                     medianData(s,ch,win,fq,con) = mean(data_behav_tmp(ind_high)) - mean(data_behav_tmp(ind_low));
                 end           
             end          
         end     
     end
 end
 
% average over channels 
medianData = squeeze(mean(medianData,2));

% weights = [% all conditions
%           eye(9);
%           ];
weights = [% average over bands
          1/3 0 0 1/3 0 0 1/3 0 0;
          0 1/3 0 0 1/3 0 0 1/3 0;
          0 0 1/3 0 0 1/3 0 0 1/3;
          ];
contrast_names = {'Match';
                  'Mismatch';
                  'Neutral';
                  };
% weights = [% 4 bands only
%           0 0 0 1 0 0 0 0 0;
%           0 0 0 0 1 0 0 0 0; 
%           0 0 0 0 0 1 0 0 0; 
%           ];
% weights = [% 8 bands only
%           0 0 0 0 0 0 1 0 0;
%           0 0 0 0 0 0 0 1 0; 
%           0 0 0 0 0 0 0 0 1; 
%           ];

count = 0;
data_contrast = [];
data_labels = {};
F_all = [];
for win=1:length(windows)
    
    for fq=1:length(freqRange)
        
        for wt=1:size(weights,1)
            
            count = count + 1;
            data_contrast(:,count) = sum(squeeze(medianData(:,win,fq,:)) .* repmat(weights(wt,:),length(subjects),1),2);
            
        end
        
        data_labels{count} = [num2str(windows{win}(1)) 'ms_' num2str(freqRange{fq}(1)) 'Hz_' contrast_names{wt}];
        
        [efs,F,cdfs,p,eps,dfs,b,y2,sig] = repanova(data_contrast(:,count-2:count),[3],{'Congruency'},0);
        F_all(fq,win) = F;
        
        [discard1 discard2 discard3 stats] = ttest(mean(data_contrast,2));
        t_all(fq,win,1) = stats.tstat;
        [discard1 discard2 discard3 stats] = ttest(data_contrast(:,count-2)-data_contrast(:,count-1));
        t_all(fq,win,2) = stats.tstat;
        [discard1 discard2 discard3 stats] = ttest(data_contrast(:,count-2)-data_contrast(:,count));
        t_all(fq,win,3) = stats.tstat;
        [discard1 discard2 discard3 stats] = ttest(data_contrast(:,count-1)-data_contrast(:,count));
        t_all(fq,win,4) = stats.tstat;
        
    end
    
end

df = [13];
p = [.05 .01];
thresh(1) = spm_invTcdf(1-abs(p(1)),df);
thresh(2) = spm_invTcdf(1-abs(p(2)),df);

figure;

imagesc(1:3,1:3,t_all(:,:,1)); axis xy; colormap(hot); caxis([thresh(1) thresh(2)]); colorbar;
set(gca,'xtick',[1:length(windows)]);
set(gca,'xticklabel',{'400-600ms' '600-800ms' '800-1000ms'});
set(gca,'ytick',[1:length(freqRange)]);
set(gca,'yticklabel',{'4-7Hz' '8-12Hz' '13-30Hz' '31-48Hz' '52-90Hz'});
title('High power > Low power');

figure;

subplot(3,1,1);
imagesc(1:3,1:5,t_all(:,:,2)); axis xy; colormap(hot); caxis([thresh(1) thresh(2)]); colorbar;
set(gca,'xtick',[1:length(windows)]);
set(gca,'xticklabel',{'400-600ms' '600-800ms' '800-1000ms'});
set(gca,'ytick',[1:length(freqRange)]);
set(gca,'yticklabel',{'4-7Hz' '8-12Hz' '13-30Hz' '31-48Hz' '52-90Hz'});
title('Match>Mismatch');
subplot(3,1,2);
imagesc(1:3,1:5,t_all(:,:,3)); axis xy; colormap(hot); caxis([thresh(1) thresh(2)]); colorbar;
set(gca,'xtick',[1:length(windows)]);
set(gca,'xticklabel',{'400-600ms' '600-800ms' '800-1000ms'});
set(gca,'ytick',[1:length(freqRange)]);
set(gca,'yticklabel',{'4-7Hz' '8-12Hz' '13-30Hz' '31-48Hz' '52-90Hz'});
title('Match>Neutral');
subplot(3,1,3);
imagesc(1:3,1:5,t_all(:,:,4)); axis xy; colormap(hot); caxis([thresh(1) thresh(2)]); colorbar;
set(gca,'xtick',[1:length(windows)]);
set(gca,'xticklabel',{'400-600ms' '600-800ms' '800-1000ms'});
set(gca,'ytick',[1:length(freqRange)]);
set(gca,'yticklabel',{'4-7Hz' '8-12Hz' '13-30Hz' '31-48Hz' '52-90Hz'});
title('Mismatch>Neutral');


% df = [2 26];
% p = [.05 .01];
% thresh(1) = spm_invFcdf(1-abs(p(1)),df);
% thresh(2) = spm_invFcdf(1-abs(p(2)),df);
% 
% figure;
% imagesc(1:3,1:5,F_all); axis xy; colormap(hot); caxis([thresh(1) thresh(2)]); colorbar;
% set(gca,'xtick',[1:length(windows)]);
% set(gca,'xticklabel',{'400-600ms' '600-800ms' '800-1000ms'});
% set(gca,'ytick',[1:length(freqRange)]);
% set(gca,'yticklabel',{'4-7Hz' '8-12Hz' '13-30Hz' '31-48Hz' '52-90Hz'});
% title('Main effect of congruency');
   

% % recode into spss format and output as tab delimited text file
% 
% % SPSS variable names
% conditions_spss = data_labels;
% nconditions = size(data_contrast,2);
% nsubjects = size(data_contrast,1);
% 
% % prepare spss output file
% outputfilename = [pathstem 'single-trial_spss.txt'];
% fid = fopen(outputfilename,'w');
% 
% % write variables names to top row
% for c=1:nconditions
%     fprintf(fid,conditions_spss{c});
%     if c==nconditions
%         fprintf(fid,'\n');
%     else
%         fprintf(fid,'\t');
%     end
% end
% 
% % write data to rows below variable names
% spef = repmat('%.2f\t',1,nconditions); % fprintf specifiers for numeric data
% spef = spef(1:length(spef)-1); % remove trailing tab
% for s=1:nsubjects
%     fprintf(fid,spef,data_contrast(s,:));
%     fprintf(fid,'\n');
% end
% 
% status = fclose(fid);
