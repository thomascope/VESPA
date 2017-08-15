% Subject and file details

condition = {'8_0-8','4_0-4','2_0-2'};

subject_mat = {'275-028', '288-004', '288-013'};
% {'348', '263', '330-007', '275-015', '275-028', '288-004', '288-013'} completed.
% {'258-020', '258-019', '210-045'} No bipolar pairs in HG with significant enough activity to be included in further analysis.
% {'212-015', '251-031', '237-028'} MEX file error

for m = 1:numel(subject_mat)
    
load (['X:\auditory\Daniyal\ECog data\',subject_mat{m},'\',subject_mat{m},'_',condition{1},'_silent_ground_ERSP_difference.mat']);
load (['X:\auditory\Daniyal\ECog data\',subject_mat{m},'\',subject_mat{m},'_preprocess_',condition{1},'.mat']); 

clear sig_pairs tscore_dist tfdata_silent tfdata_ground

method = 'granger';                     %you can try using other methods from the connectivity 
spectrum = [method 'spctrm'];            %function in fieldtrip. It requires heavy editing to work.

srate = 1000;

data_sub = EEG.data((corr_sig_pairs),:,:);
nchans = numel(data_sub(:,1,1));

start_times = 1200;
end_times = 1900;
ntimes = numel(start_times);

for n = 1:11

nperm = 10;    % number of permutations 

nptmp = nperm;
if n == 11
    nptmp = 1;
end

temp_granger_data = nan(nchans,nchans,ntimes,70,2,nptmp);               % Generate empty matrix to hold all results - from x to x time x freq x condition x number of permutations
granger_data = temp_granger_data;
coh = find(All_Conds==8);

for p = 1:nptmp
    randcond = randperm(numel(All_Conds));
    rcoh = randcond(1:numel(coh));
    rctrl = randcond(numel(coh)+1:numel(All_Conds));
    if n == 11
       rcoh = coh;
       rctrl = find(All_Conds == 80);
    end
    
for t = 1:ntimes

Tmin = start_times(t)/1000; %specify time window to be used (usually 0.7-1.2 or 1.2-1.9)
Tmax = end_times(t)/1000;

times = EEG.times/1000;
tIdx =find(times >= Tmin & times <= Tmax);
times =times(tIdx);

%%

for chan_from = 1:(nchans - 1)% For loops for every channel pair combination
for chan_to = (chan_from+1):nchans
    chans = [chan_from; chan_to];


for cond = 1:2    % For loop for each condition (figure vs control)
    ftdata = [];        % create ft data structure

%     odata.trial =permute(double(Z{cond}),[3 1 2]);
    if cond == 1    
        ftdata.trial = permute(double(EEG.data(chans,tIdx,rcoh)),[3,1,2]); %if cond == 1 then this line. If cond == 2 then look for All_Conds==80
    elseif cond == 2
        ftdata.trial = permute(double(EEG.data(chans,tIdx,rctrl)),[3,1,2]);
    end
    for k=1:(length(chans))
        ftdata.label{k,1}=['Chan_' num2str(k)];
    end
    ftdata.dimord ='rpt_chan_time';
    ftdata.time=double(times);
    
%%
nsamples = size(ftdata.trial, 3); %get number of sample (time) points
fsample = srate;
fstep = fsample/nsamples; 
fstep = ceil(1/fstep)*fstep;
% fstep = 3; %%%

freqmax = 100;
foi     = 0:fstep:freqmax;

% fres    = 4 * ones(size(foi));
fres    = 2.5 * ones(size(foi));

    fsample = srate;
    channelcmb = ftdata.label; %get channel names that were generated for the odata
    
    cfg = [];
    cfg.output ='fourier';
    cfg.channelcmb=channelcmb;

    cfg.keeptrials = 'yes';
    cfg.keeptapers='yes';
    cfg.taper = 'dpss';
    cfg.method = 'mtmfft';
    cfg.foi     = foi;
    cfg.tapsmofrq = fres;

    inp = ft_freqanalysis(cfg, ftdata);

    cfg = [];
    cfg.channelcmb=channelcmb;

    cfg.method = method;
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

    temp_granger_data(chan_from,chan_to,t,:,cond,p) = res.grangerspctrm(2,(2:(length(foi))));
    temp_granger_data(chan_to,chan_from,t,:,cond,p) = res.grangerspctrm(3,(2:(length(foi))));

    fprintf(['\n\n\nBlock ',num2str(n),', perm ',num2str(p),', time ',num2str(t),', channel ',num2str(chan_from),'-',num2str(chan_to),', cond ',num2str(cond),'\n\n\n']);
    
% end of for loops
end
end
end
end
end
foi = foi(2:end);
save([subject_mat{m},'_',condition{1},'_grangerdata_fres2_5_1200_1900_',num2str(n)],'bipolar_labels','corr_sig_pairs','temp_granger_data','start_times','end_times','foi');
end
%% save results

granger_data = [];

for z = 1:11    
% load (['X:\auditory\Daniyal\ECog Data\288-004\288-004_8_0-8_grangerdata_shorttimes_',num2str(z),'.mat']);
load (['X:\auditory\Daniyal\ECog Data\',subject_mat{m},'_',condition{1},'_grangerdata_fres2_5_1200_1900_',num2str(z),'.mat']);
granger_data = cat(6,granger_data,temp_granger_data);
end

% save(['288-004_8_0-8_grangerdata_shorttimes'],'bipolar_labels','corr_sig_pairs','granger_data','start_times','end_times','foi');
save([subject_mat{m},'_',condition{1},'_grangerdata_fres2_5_1200_1900'],'bipolar_labels','corr_sig_pairs','granger_data','start_times','end_times','foi');
end

