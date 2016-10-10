%% Initialise path and subject definitions

es_batch_init;

%% Extract imaging data from specified time-windows and brain regions

% time windows of imaging data
windows = {
          {[90 130] [90 130]}; 
          {[180 240] [180 240]};
          {[270 420] [270 420]};
          {[450 700] [450 700]};
          
          %{[90 130] [450 700]};
          %{[90 130] [450 700]};
          };

% coordinate (region) of imaging data...
% XYZ = {
%       {[-38 36 30] [-50 -26 14]};
%       {[-38 36 30] [-50 -26 14]};
%       };

% ... or ROI of imaging data (marsbar toolbox needs to have been launched)
XYZ = {
      {'/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      {'/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      {'/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      {'/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      
      %{'/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      %{'/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_source_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      };
  
data_imaging = {};
for s=1:length(subjects)
    
    for win=1:size(windows,1)
        
        for con=1:length(conditions)
            
            for reg=1:length(XYZ{win})
                               
                files = dir([pathstem subjects{s} '/Source/*5_t' num2str(windows{win}{reg}(1)) '_' num2str(windows{win}{reg}(2)) '_f1_40_' num2str(con) '_*.nii']);
                
                for trl=1:length(files)
                    
                    filename = [pathstem subjects{s} '/Source/' files(trl).name];
                    
                    if ischar(XYZ{1}{1}) % get data from ROI (averaged across voxels within ROI)
                        % Make marsbar ROI object
                        R  = maroi(XYZ{win}{reg});
                        % Fetch data into marsbar data object
                        Y  = get_marsy(R, filename, 'mean');
                        % Summarise data (access mean calculated from previous step)
                        Y = summary_data(Y);
                        data_imaging{s}(win,con,reg,trl) = Y;
                    else % get data from single voxel
                        data_imaging{s}(win,con,reg,trl) = get_raw_data(XYZ{win}{reg},filename,0,0);
                    end
                    
                end
                
            end
            
        end
        
    end
    
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
            
            ind = D.pickconditions(conditions{con});
            
            for trl=1:length(ind)
                
                count = count + 1;
                data_behav{s}(count,con) = D.events_custom(ind(trl)).rating;
                
            end
            
        end
        
    end
        
end

%% Collate imaging data, determine distribution parameters and visualise (assumes two regions as input)

cutoff1 = [];
cutoff2 = [];
for s=1:length(subjects)
    for win=1:size(windows,1)
        data_imaging_tmp1 = [];
        data_imaging_tmp2 = [];
        for con=1:length(conditions)
            data_imaging_tmp1 = [data_imaging_tmp1; squeeze(data_imaging{s}(win,con,1,:))];
            data_imaging_tmp2 = [data_imaging_tmp2; squeeze(data_imaging{s}(win,con,2,:))];       
        end
        data_imaging_tmp1(data_imaging_tmp1==0) = []; % need to remove empty data points since conditions have non-equal numbers of trials (due to artefact removal)
        data_imaging_tmp2(data_imaging_tmp2==0) = [];
        data_imaging_combined = [data_imaging_tmp1 data_imaging_tmp2];
        
        % get distribution mean and std
        mean_tmp = mean(data_imaging_combined(:,1));
        std_tmp = std(data_imaging_combined(:,1),1,1);
        cutoff1(s,win) = mean_tmp + std_tmp*3;
        mean_tmp = mean(data_imaging_combined(:,2));
        std_tmp = std(data_imaging_combined(:,2),1,1);
        cutoff2(s,win) = mean_tmp + std_tmp*3;
        
        % plot
%         figure; scatter(data_imaging_combined(:,1),data_imaging_combined(:,2),'.');
%         line([cutoff1(s,win) cutoff1(s,win)],[0 max(data_imaging_combined(:,2))],'Color','r');
%         line([0 max(data_imaging_combined(:,1))],[cutoff2(s,win) cutoff2(s,win)],'Color','r');
%         title([subjects{s} ' Win ' num2str(windows{win}{1})]);
%         getkey; close(gcf);
    end
end

%% Correlation between region-region (assumes two regions as input)

r_corr_all = [];
beta_all = [];
for s=1:length(subjects)
    for win=1:size(windows,1)
        for con=1:length(conditions)
            data_imaging_tmp1 = squeeze(data_imaging{s}(win,con,1,:));
            %fprintf('\n%3.2f',(sum(data_imaging_tmp1 > cutoff1(s,win)) / length(data_imaging_tmp1)) * 100);
            data_imaging_tmp1(data_imaging_tmp1==0) = NaN; % need to NaN data points since conditions have non-equal numbers of trials (due to artefact removal)
            data_imaging_tmp1( data_imaging_tmp1 > cutoff1(s,win) ) = NaN;
            data_imaging_tmp2 = squeeze(data_imaging{s}(win,con,2,:));
            %fprintf('\n%3.2f',(sum(data_imaging_tmp2 > cutoff2(s,win)) / length(data_imaging_tmp2)) * 100);
            data_imaging_tmp2(data_imaging_tmp2==0) = NaN;
            data_imaging_tmp2( data_imaging_tmp2 > cutoff2(s,win) ) = NaN;
            data2correlate = [data_imaging_tmp1 data_imaging_tmp2];
            
            % correlation coefficient (pearsons r)
            r_corr = corr(data2correlate,'rows','complete');
            r_corr_all(s,win,con) = r_corr(1,2);
            r_corr_all(s,win,con) = atanh(r_corr_all(s,win,con)); % fisher transform
            r_corr_all(s,win,con) = r_corr_all(s,win,con)/inv(sqrt(size(data2correlate,1)-3)); % convert into z-score
            
            % beta coefficient
            b = regress(data_imaging_tmp1,[ones(size(data_imaging_tmp2,1),1) data_imaging_tmp2]);
            beta_all(s,win,con) = b(2);
        end
    end
end

%data2anova = r_corr_all;
data2anova = beta_all;

%% Correlation between region-behaviour

reg = 1; % select one region

if reg == 1
    cutoff = cutoff1;
elseif reg == 2
    cutoff = cutoff2;
end
   
r_corr_all = [];
p_corr_all = [];
beta_all = [];
for s=1:length(subjects)
    for win=1:size(windows,1)
        for con=1:length(conditions)
            data_imaging_tmp = squeeze(data_imaging{s}(win,con,reg,:));
            data_imaging_tmp(data_imaging_tmp==0) = NaN; % need to NaN data points since conditions have non-equal numbers of trials (due to artefact removal)
            data_imaging_tmp( data_imaging_tmp > cutoff(s,win) ) = NaN;
            data_behav_tmp = data_behav{s}(:,con);
            data_behav_tmp(data_behav_tmp==0) = NaN;
            data2correlate = [data_imaging_tmp data_behav_tmp];
            
            % correlation coefficient (pearsons r)
            [r_corr p_corr] = corr(data2correlate,'rows','complete');
            r_corr_all(s,win,con) = r_corr(1,2);
            p_corr_all(s,win,con) = p_corr(1,2);
            %r_corr_all(s,win,con) = atanh(r_corr_all(s,win,con)); % fisher transform
            %r_corr_all(s,win,con) = r_corr_all(s,win,con)/inv(sqrt(size(data2correlate,1)-3)); % convert into z-score
            
            % beta coefficient
            b = regress(data_imaging_tmp,[ones(size(data_behav_tmp,1),1) data_behav_tmp]);
            beta_all(s,win,con) = b(2);
            
            % plot scatter graph
            %figure;scatter(data_imaging_tmp,data_behav_tmp);
            
        end
    end
end

%data2anova = r_corr_all;
data2anova = beta_all;

%% Compute contrast and t-test for each time-window

%weights = [-1/3 -1/3 -1/3 0 0 0 1/3 1/3 1/3]; % 8ch>2ch
%weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N)
weights = [0 0 0 1 -0.5 -0.5 0 0 0]; % M-(MM+N) 4 bands only

p_ttest = [];
data_contrast = [];
for win=1:size(windows,1)
     
    tmp = [];
    for wt=1:size(weights,1)
        data_contrast(:,win) = sum(squeeze(data2anova(:,win,:)).* repmat(weights(wt,:),length(subjects),1),2);
        [h p] = ttest(data_contrast(:,win));
        p_ttest(win) = p;
    end
    
end

%% Compute contrast and ANOVA across time-windows
% Also does some plotting

weights = [
          -1/3 -1/3 -1/3 0 0 0 1/3 1/3 1/3; % 8ch>2ch
          1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6; % M-(MM+N)
          ];  

count = 0;
data_contrast = [];
for win=1:size(windows,1)
%for win=[1 4]
     
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

data_contrast_adj = es_removeBetween(data_contrast);

data_contrast_means = [];
data_contrast_sems = [];
count = 0;
for win=1:size(windows,1)
%for win=[1 4]
     
    for wt=1:size(weights,1)
        
        count = count + 1;
        data_contrast_means(win,wt) = mean(data_contrast_adj(:,count),1);
        data_contrast_sems(win,wt) = std(data_contrast_adj(:,count),1)/sqrt(size(data_contrast_adj(:,count),1));
        
    end
 
end

colors = {'r' 'b'};

figure;
for wt=1:size(weights,1)
    errorbar(1:size(windows,1),data_contrast_means(:,wt),data_contrast_sems(:,wt),colors{wt},'linewidth',2); hold on   
end

legend({'From sensory detail' 'From prior knowledge'});
%set(gca,'xtick',1:size(windows,1));
%set(gca,'xticklabel',{'90-130ms' '180-240ms' '270-420ms' '450-700ms'});
ylabel('Change in connectivity (pearsons r)');