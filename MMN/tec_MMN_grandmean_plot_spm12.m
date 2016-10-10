% parameters
%file2plot = ['/imaging/tc02/vespa/preprocess/MMN/Grand means/ControlGM.mat ';'/imaging/tc02/vespa/preprocess/MMN/Grand means/patientsgm.mat'];
file2plot = {'/imaging/tc02/vespa/preprocess/MMN/Firstpreprocess/controlgrandmean.mat ';'/imaging/tc02/vespa/preprocess/MMN/Firstpreprocess/patientgrandmean.mat'};
chanlabel = {'MEG' 'MEGPLANAR' 'EEG'}; % Plot selected channels or modality (if modality, can choose to plot rms or all channels- see rms variable below)
%con2plot = conditions;
%con_labels = {'standard','deviant','location','intensity','duration','gap','frequency','location_L','frequency_high','intensity_high','location_R','intensity_low','frequency_low'};
con2plot = {'standard','deviant'};
con2contrast = {'standard','deviant'};
%con2contrast = {'standard','intensity'};
legendnames = {'control standard','patient standard','control deviant','patient deviant'};
contrastnames = {'control MMN', 'patient MMN'};
styles = {'-r' '-b' '--r' '--b' '*r' '*b'};
plotRange = [-100 400]; % total time range to plot
rms = 1; % if modality has been specified above (rather than single channel), plot all channels (0) or rms (1)

% load grand average
D = spm_eeg_load(file2plot{1,:});
S = spm_eeg_load(file2plot{2,:});
times = D.time * 1000;

% determine sample range to plot
startSample = nearestpoint(plotRange(1),times);
endSample = nearestpoint(plotRange(2),times);

% make figure
figure;

storedata = []; % needed for shading time windows
for ty = 1:length(chanlabel)
    figure
    for c=1:length(con2plot)
        
        % get channels indices for specified modality
        %        chaninds = D.indchantype(chanlabel{ty});
        chaninds = D.indchantype(chanlabel{ty});
        % get condition index
%         coninds = D.indtrial(con2plot{c});
        coninds = D.indtrial(con2plot{c});
        % get data for selected channels and current condition
        datacont = D(chaninds,:,coninds);
        if rms
            % get rms over channels
            datacont = sqrt(mean(datacont.^2,1));
        end
    
    % specify name of dependent measure (and convert data to sensible
    % units)
    if sum(strcmp(chanlabel{ty},'MEG')) || ~isempty(intersect(D.indchantype('MEG'),D.indchannel(chanlabel{ty}))) % MEGMAG
        measure = 'Amplitude (fT)';
        datacont = datacont * 1e15;
    elseif sum(strcmp(chanlabel{ty},'MEGPLANAR')) || ~isempty(intersect(D.indchantype('MEGPLANAR'),D.indchannel(chanlabel{ty}))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        datacont = datacont * 1e15;
    elseif sum(strcmp(chanlabel{ty},'EEG')) || ~isempty(intersect(D.indchantype('EEG'),D.indchannel(chanlabel{ty}))) % EEG
        measure = 'Amplitude (\muV)';
        datacont = datacont * 1e6;
    end
    
    % get channels indices for specified modality
    chaninds = S.indchantype(chanlabel{ty});
    % get condition index
    coninds = S.indtrial(con2plot{c});
    % get data for selected channels and current condition
    datapat = S(chaninds,:,coninds);
    if rms
        % get rms over channels
        datapat = sqrt(mean(datapat.^2,1));
    end
    
    if sum(strcmp(chanlabel{ty},'MEG')) || ~isempty(intersect(D.indchantype('MEG'),D.indchannel(chanlabel{ty}))) % MEGMAG
        measure = 'Amplitude (fT)';
        datapat = datapat * 1e15;
    elseif sum(strcmp(chanlabel{ty},'MEGPLANAR')) || ~isempty(intersect(D.indchantype('MEGPLANAR'),D.indchannel(chanlabel{ty}))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        datapat = datapat * 1e15;
    elseif sum(strcmp(chanlabel{ty},'EEG')) || ~isempty(intersect(D.indchantype('EEG'),D.indchannel(chanlabel{ty}))) % EEG
        measure = 'Amplitude (\muV)';
        datapat = datapat * 1e6;
    end
    
    % plot
    plot(times(startSample:endSample),datacont(:,startSample:endSample),styles{c},'linewidth',2); hold all
    plot(times(startSample:endSample),datapat(:,startSample:endSample),styles{c+2},'linewidth',2); hold all
    
    
end


% if mean across time and conditions negative, reverse y axis
if mean(mean(datacont)) < 0
    set(gca,'YDir','Reverse');
end
set(gca,'FontSize',12,'FontWeight','Bold');
xlabel('Time (ms)');
ylabel(measure);
legend(legendnames);
end

for ty = 1:length(chanlabel)
    figure

        % get channels indices for specified modality
        chaninds = D.indchantype(chanlabel{ty});
        % get condition index
        firstinds = D.indtrial(con2contrast{1});
        secondinds = D.indtrial(con2contrast{2});
        % get data for selected channels and current condition
        datacont = sqrt(mean(D(chaninds,:,firstinds).^2,1)) - sqrt(mean(D(chaninds,:,secondinds).^2,1));
    
    % specify name of dependent measure (and convert data to sensible
    % units)
    if sum(strcmp(chanlabel{ty},'MEG')) || ~isempty(intersect(D.indchantype('MEG'),D.indchannel(chanlabel{ty}))) % MEGMAG
        measure = 'Amplitude (fT)';
        datacont = datacont * 1e15;
    elseif sum(strcmp(chanlabel{ty},'MEGPLANAR')) || ~isempty(intersect(D.indchantype('MEGPLANAR'),D.indchannel(chanlabel{ty}))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        datacont = datacont * 1e15;
    elseif sum(strcmp(chanlabel{ty},'EEG')) || ~isempty(intersect(D.indchantype('EEG'),D.indchannel(chanlabel{ty}))) % EEG
        measure = 'Amplitude (\muV)';
        datacont = datacont * 1e6;
    end
    
    % get channels indices for specified modality
    chaninds = S.indchantype(chanlabel{ty});
    % get condition index
        firstinds = D.indtrial(con2contrast{1});
        secondinds = D.indtrial(con2contrast{2});
    % get data for selected channels and current condition
    datapat = sqrt(mean(S(chaninds,:,firstinds).^2,1)) - sqrt(mean(S(chaninds,:,secondinds).^2,1));
    
    if sum(strcmp(chanlabel{ty},'MEG')) || ~isempty(intersect(D.indchantype('MEG'),D.indchannel(chanlabel{ty}))) % MEGMAG
        measure = 'Amplitude (fT)';
        datapat = datapat * 1e15;
    elseif sum(strcmp(chanlabel{ty},'MEGPLANAR')) || ~isempty(intersect(D.indchantype('MEGPLANAR'),D.indchannel(chanlabel{ty}))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        datapat = datapat * 1e15;
    elseif sum(strcmp(chanlabel{ty},'EEG')) || ~isempty(intersect(D.indchantype('EEG'),D.indchannel(chanlabel{ty}))) % EEG
        measure = 'Amplitude (\muV)';
        datapat = datapat * 1e6;
    end
    
    % plot
    plot(times(startSample:endSample),datacont(:,startSample:endSample),styles{c},'linewidth',2); hold all
    plot(times(startSample:endSample),datapat(:,startSample:endSample),styles{c+2},'linewidth',2); hold all
    
    


% if mean across time and conditions negative, reverse y axis
%if mean(mean(datacont)) < 0
%    set(gca,'YDir','Reverse');
%end
set(gca,'FontSize',12,'FontWeight','Bold');
xlabel('Time (ms)');
ylabel(measure);
legend(contrastnames);
end

