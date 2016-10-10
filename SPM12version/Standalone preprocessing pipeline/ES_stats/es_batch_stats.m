%% Initialise path and subject definitions

es_batch_init;

%% Specify parameters

% time windows of imaging data
windows = [
           90 130;
           %180 240;
           %270 420;
           450 700;
           ];

% if using raw sensor data
% chanlabels = {
%              {'EEG020'};
%              {'EEG020'};
%              {'MEG1221' 'EEG052' 'EEG019'};
%              {'MEG0341' 'MEG1221' 'MEG1721' 'MEG0243' 'EEG056' 'EEG009' 'EEG046'};
%              };

% if using sensor image data
% chanlabels = {
%              {'EEG'};
%              {'EEG'};
%              {'MEG' 'EEG' 'EEG'};
%              {'MEG' 'MEG' 'MEG' 'MEGPLANAR' 'EEG' 'EEG' 'EEG'};
%              };

% if using source image data
chanlabels = {
             {'Source' 'Source'};
             {'Source' 'Source'};
             };

% if using any type of image data (sensor or source)
% XYZ = {
%       {[-38 36 30] [-50 -26 14]};
%       {[-38 36 30] [-50 -26 14]};
%       };
  
% XYZ = {
%       {'/imaging/es03/P3E1/stats2_averagetime/contrasts_{13,15}_(conj_null)_-38_36_30_<0.005_roi.mat' '/imaging/es03/P3E1/stats2_averagetime/contrasts_{14,16}_(conj_null)_-56_-22_4_<0.005_roi.mat'};
%       {'/imaging/es03/P3E1/stats2_averagetime/contrasts_{13,15}_(conj_null)_-38_36_30_<0.005_roi.mat' '/imaging/es03/P3E1/stats2_averagetime/contrasts_{14,16}_(conj_null)_-56_-22_4_<0.005_roi.mat'};
%       };
XYZ = {
      {'/imaging/es03/P3E1/stats2_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      {'/imaging/es03/P3E1/stats2_averagetime/Match_(mismatch+neutral)_-42_28_26_<0.001_roi.mat' '/imaging/es03/P3E1/stats2_averagetime/Match_(mismatch+neutral)_-56_-22_4_<0.001_roi.mat'};
      };
  
  % Contrast (e.g. to do stats on diffferences between certain conditions)
  weights = [1/3 -1/6 -1/6 1/3 -1/6 -1/6 1/3 -1/6 -1/6]; % M-(MM+N)
  %weights = [1/3 -1/3 0 1/3 -1/3 0 1/3 -1/3 0]; % M-MM
  %weights = [1/3 0 -1/3 1/3 0 -1/3 1/3 0 -1/3]; % M-N
  %weights = [0 0 0 0 0 0 1/3 -1/6 -1/6]; % M-(MM+N) 8 bands
  %weights = [0 0 0 1/3 -1/6 -1/6 0 0 0]; % M-(MM+N) 4 bands
  %weights = [1/3 -1/6 -1/6 0 0 0 0 0 0]; % M-(MM+N) 2 bands
  %weights = [0 0 0 0 0 0 1 -1 0]; % M-MM 8 bands
  %weights = [0 0 0 0 0 0 1 0 -1]; % M-N 8 bands
  %weights = [0 0 0 1 -1 0 0 0 0]; % M-MM 4 bands
  %weights = [0 0 0 1 0 -1 0 0 0]; % M-N 4 bands
  %weights = [1 -1 0 0 0 0 0 0 0]; % M-MM 2 bands
  %weights = [1 0 -1 0 0 0 0 0 0]; % M-N 2 bands
  %weights = [-1/3 -1/3 -1/3 0 0 0 1/3 1/3 1/3]; % 8ch > 2ch

% filenames of behavioural data
inputfilename = '../behavioural/01.02.11.xls'; % behavioural data (mean ratings)

% for collecting data (e.g. across time windows)
combine_counter = 0;

for win=1:size(windows,1)
    
    for ch=1:length(chanlabels{win})
        
        %% Extract imaging data
        
        data_imaging = [];
        for s=1:length(subjects)
            
            % get data from smoothed image files...
            dataAvg = [];
            for c=1:length(conditions) % collect data over conditions
%                 file = dir([pathstem subjects{s} '/' chanlabels{win}{ch} '/type_' conditions{c} '/' num2str(windows(win,1)) '_' num2str(windows(win,2)) '_sm_trial*.img']);
%                 filename = [pathstem subjects{s} '/' chanlabels{win}{ch} '/type_' conditions{c} '/' file.name];
                file = dir([pathstem subjects{s} '/' chanlabels{win}{ch} '/*5_t' num2str(windows(win,1)) '_' num2str(windows(win,2)) '_f1_40_' num2str(c) '.nii']);
                filename = [pathstem subjects{s} '/' chanlabels{win}{ch} '/' file.name];
                
                if ischar(XYZ{1}{1}) % get data from ROI (averaged across voxels within ROI)
                    % Make marsbar ROI object
                    R  = maroi(XYZ{win}{ch});
                    % Fetch data into marsbar data object
                    Y  = get_marsy(R, filename, 'mean');
                    % Summarise data (access mean calculated from previous step)
                    Y = summary_data(Y);
                    dataAvg(c) = Y;
                else % get data from single voxel
                    dataAvg(c) = get_raw_data(XYZ{win}{ch},filename,0,0);
                end
            end
            
%             % ... or get data from MEEG files
%             file = dir([pathstem subjects{s} '/m*.mat']);
%             filename = [pathstem subjects{s} '/' file.name];
%             D = spm_eeg_load(filename);
%             planarind = spm_eeg_grad_pairs(D);
%             chanind = D.indchannel(chanlabels{win}{ch});
%             matchind = find(planarind == chanind);
%             if isempty(matchind) % if not MEGPLANAR, extract data from specified channel, time window and condition
%                 dataselect = D.selectdata(chanlabels{win}{ch},windows(win,:)/1000,[]);
%             else % if MEGPLANAR, do as above but first take RMS of specified channel and other channel in pair
%                 planarlabels = D.chanlabels(planarind(matchind,:));
%                 dataselect = D.selectdata(planarlabels,windows(win,:)/1000,[]);
%                 tmp = [];
%                 for c=1:length(conditions) % collect data over conditions
%                     tmp(:,:,c) = es_combineplanar(dataselect(:,:,c));
%                 end
%                 dataselect = tmp;
%             end
%             dataAvg = mean(dataselect,2); % average over time
%             dataAvg = squeeze(dataAvg)';
%             
%             % Convert data to sensible units
%             if findstr(chanlabels{win}{ch},'EEG') % EEG
%                 dataAvg = dataAvg * 1e6;
%             elseif ~isempty(matchind) % MEGPLANAR
%                 dataAvg = dataAvg * 1e15;
%             else                      % MEGMAG
%                 dataAvg = dataAvg * 1e15;
%             end
            
            data_imaging(s,:) = dataAvg; % collect data over subjects
            
        end
        
        % calculate number of subjects and conditions
        [nsubjects_imaging nconditions_imaging] = size(data_imaging);
        
        % Compute contrast
        tmp_imaging = [];
        for w=1:size(weights,1)
            tmp_imaging(:,w) = sum(data_imaging .* repmat(weights(w,:),nsubjects_imaging,1),2);    
        end
        data_contrast_imaging = tmp_imaging;    
        
        %% Extract behavioural data (for correlating with imaging data)
        
        % read .xls file and extract dimensions
        data_behav = xlsread(inputfilename);
        [nrows ncolumns] = size(data_behav);
        % find rows with data
        ind_rows = find(data_behav(:,1)>0);
        % remove condition headers and subject numbers
        data_behav = data_behav(ind_rows(1):nrows,2:ncolumns);
        % calculate number of subjects and conditions
        [nsubjects_behav nconditions_behav] = size(data_behav);
        
        if nsubjects_behav ~= nsubjects_imaging || nconditions_behav ~= nconditions_imaging
            error('Error: behavioural and imaging data dimensions do not match!');
        end
        
        % Compute contrast
        tmp_behav = [];
        for w=1:size(weights,1)
            tmp_behav(:,w) = sum(data_behav .* repmat(weights(w,:),nsubjects_behav,1),2);    
        end
        data_contrast_behav = tmp_behav;
        
        %% Collect data
        
        combine_counter = combine_counter + 1;
        
        data_behav_all(:,combine_counter) = data_contrast_behav;
        data_imaging_all(:,combine_counter) = data_contrast_imaging;    
        
    end
    
end

%% Correlation between region-region

% Correlations between regions for each time window
corr_counter = 0;
for w=1:size(windows,1)
    for ch=1:length(chanlabels{win})
        corr_counter = corr_counter + 1;
        corr_data(:,ch) = data_imaging_all(:,corr_counter);
    end
    [r_corr p_corr] = corr(corr_data);
    fprintf('\n\nCorrelation values for %d-%dms:\n',windows(w,1),windows(w,2));
    fprintf('\nP-values\n');
    p_corr
%     fprintf('\nr-values\n\n');
%     r_corr
end

%% Compute ANOVA on imaging data

fprintf('\n\n');

% ANOVA
[efs,F,cdfs,p,eps,dfs,b,y2,sig] = repanova(data_imaging_all,[size(windows,1) length(chanlabels{1})]);
