% possible fft methods: mtmfft mtmconvol wavelet
function parallel_tec_granger_averagenotsubtracted_bothperms(s,outdir,start_times,end_times,fft_method,method)

subtract_average = 0;

subjects_and_parameters;

pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/';
if ~exist('outdir','var'); outdir = [pathstem 'extractedsources/']; end
if ~exist('fft_method','var'); fft_method = 'mtmfft'; end
if ~exist('method','var'); method = 'granger'; end

% matchconds = [2,4,6];
% mismatchconds = [1,3,5];
corr_sig_pairs=1:2;  %XXX Check if this is right - original script used a variable called corr_sig_pairs

%for s=1:length(subjects)

%S = spm_eeg_load([outdir 'timeseries_for_coherence_s' num2str(s)]);
S=load([outdir 'timeseries_for_coherence_s' num2str(s)]);
S=S.D;
clear D;

%method = 'granger';                     %you can try using other methods from the connectivity
spectrum = [method 'spctrm'];            %function in fieldtrip. It requires heavy editing to work.

srate = S.Fsample; %NB: Default data are downsampled to 250Hz compared to Will's data at 1000Hz

data_sub = S.data(corr_sig_pairs,:,:);
nchans = numel(data_sub(:,1,1));

%start_times = S.timeOnset*1000;
%start_times = 32;
%end_times = start_times+((S.Nsamples-1)*1000/srate);
%end_times = 944;
ntimes = numel(start_times);

if subtract_average == 1
    S.data(:,:,:) = S.data(:,:,:) - repmat(mean(S.data(:,:,:),3),[1 1 size(S.data,3)]);
end

for n = 1:21
    
    nperm = 10;    % number of permutations
    
    nptmp = nperm;
    if n == 21
        nptmp = 1;
    end
    
    %temp_granger_data = nan(nchans,nchans,ntimes,70,2,nptmp);               % XXX why 70 freqs and 2 conditions? % Generate empty matrix to hold all results - from x to x time x freq x condition x number of permutations
    %temp_granger_data = nan(nchans,nchans,ntimes,91,numel(conditions),nptmp);
    
    All_labels = strvcat(S.trials.label);
    All_Conds = zeros(1,size(All_labels,1));
    for cond = 1:numel(conditions)
        All_Conds(strcmp(conditions(cond),cellstr(All_labels))) = cond;
    end
    
    for p = 1:nptmp
        
        if n <= 10
            randcond = All_Conds(randperm(numel(All_Conds))); %first 100 perms, randomise condition labels 
        elseif n <= 20
            randcond_1 = All_Conds(randperm(numel(All_Conds)));  %shuffle trial numbers in 101:200
            randcond_2 = All_Conds(randperm(numel(All_Conds)));
        else
            randcond = All_Conds; %Not random in 21st perm
        end
        
        for t = 1:ntimes
            
            Tmin = start_times(t)/1000; %specify time window to be used (usually 0.7-1.2 or 1.2-1.9)
            Tmax = end_times(t)/1000;
            
            times = S.timeOnset:1/srate:S.timeOnset+((S.Nsamples-1)/srate); %In seconds now!
            %times = EEG.times/1000;
            tIdx =find(times >= Tmin-eps & times <= Tmax+eps); %Edited because of floating point
            times =times(tIdx);
            
            %%
            
            for chan_from = 1:(nchans - 1)% For loops for every channel pair combination %XXX Does this do both directions??
                for chan_to = (chan_from+1):nchans
                    chans = [chan_from; chan_to];
                    
                    
                    for cond = 1:numel(conditions)    % For loop for each condition 
                        ftdata = [];        % create ft data structure
                        
                        %     odata.trial =permute(double(Z{cond}),[3 1 2]);
                        
                        
                        if n <= 10
                            ftdata.trial = permute(double(S.data(chans,tIdx,find(randcond==cond))),[3,1,2]); %Reorder into FT structure
                        elseif n <= 20
                            ftdata_temp = [];
                            ftdata_temp.trial1 = permute(double(S.data(chans,tIdx,find(randcond_1==cond))),[3,1,2]); %Reorder into FT structure
                            ftdata_temp.trial2 = permute(double(S.data(chans,tIdx,find(randcond_2==cond))),[3,1,2]); %Reorder into FT structure
                            ftdata.trial = [ftdata_temp.trial1(:,1,:),ftdata_temp.trial2(:,2,:)];
                            clear ftdata_temp
                        else
                            ftdata.trial = permute(double(S.data(chans,tIdx,find(randcond==cond))),[3,1,2]); %Reorder into FT structure
                        end
                        
                        
                        for k=1:(length(chans))
                            %ftdata.label{k,1}=['Chan_' num2str(k)];
                            ftdata.label{k,1}=S.channels(k).label;
                        end
                        bipolar_labels = ftdata.label; % XXX ?? Substitute for previous loaded value?
                        ftdata.dimord ='rpt_chan_time';
                        ftdata.time=double(times);
                        
                        %%
                        nsamples = size(ftdata.trial, 3); %get number of sample (time) points
                        fsample = srate;
                        fstep = fsample/nsamples;
                        fstep = ceil(1/fstep)*fstep;
                        % fstep = 3; %%%
                        
                        freqmax =  40; %XXX edited from 100 to 40 because of filtering
                        foi     = 0:fstep:freqmax;
                        
                        %fres    = 4 * ones(size(foi));
                        fres    = 2.5 * ones(size(foi)); %XXX what is this? Frequency smoothing? Answer - yes - +/-
                        
                        fsample = srate;
                        channelcmb = ftdata.label; %get channel names that were generated for the odata
                        
                        cfg = [];
                        cfg.output ='fourier';
                        cfg.channelcmb=channelcmb;
                        
                        cfg.keeptrials = 'yes';
                        cfg.keeptapers='yes';
                        
                        cfg.method = fft_method;
                        cfg.foi     = foi;
                        switch fft_method
                            case 'wavelet'
                                cfg.toi = times;
                                cfg.foi = foi(foi>=4); %As restricted timewindow
                            case 'mtmfft'
                                cfg.taper = 'dpss';
                                cfg.tapsmofrq = fres;
                            case 'mtmconvol'
                                cfg.taper = 'dpss';
                                cfg.tapsmofrq = fres;
                        end
                        
                        inp = ft_freqanalysis(cfg, ftdata);
                        
                        cfg = [];
                        cfg.channelcmb=channelcmb;
                        
                        cfg.method = method;
                        switch method
                            case 'coh'
                                cfg.complex = 'imag';
                        end
                        %cfg.granger.init = 'rand';
                        res = ft_connectivityanalysis(cfg, inp);
                        
                        %% plot
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %     figure;
                        %     subplot(1, 2, 1);
                        %     set(gca, 'OuterPosition', [0 0 0.5 .95]);
                        %     colours = {[1, 1, 0],[1, 0.5, 0],[1, 0 ,0],[0, 1, 1],[0, 0.5, 1],[0 ,0, 1]};
                        %     hold on
                        %
                        %     plot(res.freq((2:(length(foi)))), res.grangerspctrm(2,(2:(length(foi)))));
                        %
                        % %     title([signal1 ' to ' signal2])
                        %
                        %
                        %     subplot(1, 2, 2);
                        %     set(gca, 'OuterPosition', [0.5 0 0.5 .95]);
                        %     colours = {[1, 1, 0],[1, 0.5, 0],[1, 0 ,0],[0, 1, 1],[0, 0.5, 1],[0 ,0, 1]};
                        %     hold on;
                        %     plot(res.freq((2:(length(foi)))), res.grangerspctrm(3,(2:(length(foi)))));
                        
                        %plot(res{1}{1}.freq(2:90), res{cond}{2}.grangerspctrm(3,2:90), 'r');
                        %     title([signal2 ' to ' signal1])
                        %     suptitle(['Connectivity between ' signal1 ':' num2str(x1) '/' num2str(x2) ' and ' signal2 ':' num2str(y1) '/' num2str((y2)) ' in the time Interval ' num2str(Tmin) ' to ' num2str(Tmax)]);
                        
                        % Add key results from res.grangerspctrm to master matrix: channels
                        % compared, frequency and granger values.
                        
                        switch method
                            case 'granger'
                                if ~exist('temp_granger_data','var')
                                    temp_granger_data = nan(nchans,nchans,ntimes,length(foi)-1,numel(conditions),nptmp);
                                end
                                temp_granger_data(chan_from,chan_to,t,:,cond,p) = res.grangerspctrm(2,(2:(length(foi))));
                                temp_granger_data(chan_to,chan_from,t,:,cond,p) = res.grangerspctrm(3,(2:(length(foi))));
                            case 'coh'
                                if ~exist('temp_granger_data','var')
                                    temp_granger_data = nan(nchans,nchans,ntimes,length(foi)-1,numel(conditions),nptmp);
                                end
                                temp_granger_data(chan_from,chan_to,t,:,cond,p) = res.cohspctrm(1,2,2:length(foi));
                                temp_granger_data(chan_to,chan_from,t,:,cond,p) = res.cohspctrm(2,1,2:length(foi));
                        end
                        
                        fprintf(['\n\n\nBlock ',num2str(n),', perm ',num2str(p),', time ',num2str(t),', channel ',num2str(chan_from),'-',num2str(chan_to),', cond ',num2str(cond),'\n\n\n']);
                        
                        % end of for loops
                    end
                end
            end
        end
    end
    foi = foi(2:end);
    save([outdir 's' num2str(s) '_grangerdata_averagenotsubtracted' num2str(start_times) '_' num2str(end_times) '_z' num2str(n)],'bipolar_labels','corr_sig_pairs','temp_granger_data','start_times','end_times','foi');
end
%% save results

combined_granger_data = [];

for z = 1:21
    % load (['X:\auditory\Daniyal\ECog Data\288-004\288-004_8_0-8_evoked_grangerdata_shorttimes_',num2str(z),'.mat']);
    load ([outdir 's' num2str(s) '_grangerdata_averagenotsubtracted' num2str(start_times) '_' num2str(end_times) '_z' num2str(z)])
    combined_granger_data = cat(6,combined_granger_data,temp_granger_data);
end

granger_data = combined_granger_data;

% save(['288-004_8_0-8_evoked_grangerdata_shorttimes'],'bipolar_labels','corr_sig_pairs','granger_data','start_times','end_times','foi');
save([outdir 's' num2str(s) '_grangerdata_averagenotsubtracted' num2str(start_times) '_' num2str(end_times) '_overall'],'bipolar_labels','corr_sig_pairs','granger_data','start_times','end_times','foi');


