%% Initialise path and subject definitions

%% Single subject ERP analysis (averaging over conditions)

% parameters
PatD = load('weightedcontrolsalldatasets.mat');
ConD = load('weightedpatientsalldatasets.mat');
% file2plot = 'fmcfbMdspm8_run1_raw_ssst.mat';
modality = {'MEG' 'MEGPLANAR' 'EEG'};
plotRange = [-100 800]; % total time range to plot


%% Plot grand average ERPs for selected conditions

con2plot = PatD.F{1}.conditions; %Assumes conditions the same for all patients and controls
styles = {'-k' '-b' '-r'};
plotRange = [-100 800]; % total time range to plot in ms

rms = 0;

times = PatD.F{1}.time * 1000; % convert timescale to ms

% determine sample range to plot
[startSample startSample] = min(abs(plotRange(1)-times));
[endSample endSample] = min(abs(plotRange(2)-times));

storedata = []; % needed for shading time windows
% for m = 1:length(modality)
%     chanlabel = modality(m);
%     for c=1:length(con2plot)
%
%         if sum(strcmp(chanlabel,{'MEG' 'MEGPLANAR' 'EEG'}))
%
%             % get channels indices for specified modality
%             chaninds = PatD.indchantype(chanlabel);
%             % get condition index
%             coninds = PatD.indtrial(con2plot{c});
%             % get data for selected channels and current condition
%             Patdata = PatD(chaninds,:,coninds);
%             Condata = ConD(chaninds,:,coninds);
%             if rms
%                 % get rms over channels
%                 Patdata = sqrt(mean(Patdata.^2,1));
%                 Condata = sqrt(mean(Condata.^2,1));
%             else
%                 Patdata = mean(Patdata,1);
%                 Condata = mean(Condata,1);
%             end
%
%         else %if wanting to plot a single channel only
%
%             % get channel indices
%             chaninds = PatD.indchannel(chanlabel);
%             % get condition index
%             conind = PatD.pickconditions(con2plot{c});
%             % get data for selected channels and current condition
%             Patdata = PatD(chaninds,:,conind);
%             Condata = ConD(chaninds,:,conind);
%
%         end
%
%         % specify name of dependent measure (and convert data to sensible
%         % units)
%         if sum(strcmp(chanlabel,'MEG')) || ~isempty(intersect(PatD.indchantype('MEG'),PatD.indchannel(chanlabel))) % MEGMAG
%             measure = 'Amplitude (fT)';
%             Patdata = Patdata * 1e15;
%             Condata = Condata * 1e15;
%         elseif sum(strcmp(chanlabel,'MEGPLANAR')) || ~isempty(intersect(PatD.indchantype('MEGPLANAR'),PatD.indchannel(chanlabel))) % MEGPLANAR
%             measure = 'Amplitude (fT/m)';
%             Patdata = Patdata * 1e15;
%             Condata = Condata * 1e15;
%         elseif sum(strcmp(chanlabel,'EEG')) || ~isempty(intersect(PatD.indchantype('EEG'),PatD.indchannel(chanlabel))) % EEG
%             measure = 'Amplitude (\muV)';
%             Patdata = Patdata * 1e6;
%             Condata = Condata * 1e6;
%         end
%
%         % make figure
%         figure;
%
%         % plot
%         plot(times(startSample:endSample),Patdata(:,startSample:endSample),styles{1},'linewidth',2); hold all
%         plot(times(startSample:endSample),Condata(:,startSample:endSample),styles{2},'linewidth',2); hold all
%         plot(times(startSample:endSample),Patdata(:,startSample:endSample) - Condata(:,startSample:endSample),styles{3},'linewidth',2); hold all
%
%         %# vertical line
%         hx = graph2d.constantline(0, 'LineStyle',':', 'Color',[0 0 0]);
%         changedependvar(hx,'x');
%
%         %# horizontal line
%         hy = graph2d.constantline(0, 'LineStyle',':', 'Color',[0 0 0]);
%         changedependvar(hy,'y');
%
%         % if mean across time and conditions negative, reverse y axis
%         if mean(mean(Patdata)) < 0
%             set(gca,'YDir','Reverse');
%         end
%         set(gca,'FontSize',12,'FontWeight','Bold');
%         xlabel('Time (ms)');
%         ylabel(measure);
%         title([modality{m} ': ' con2plot{c}]);
%         legend('Patients', 'Controls', 'Contrast')
%
%     end
%
% end

for m = 1:length(modality)
    chanlabel = modality(m);
    % make figure
    figure;
    for c=1:length(con2plot)
        clear Patdata Patmeans Patstds Patstes Condata Conmeans Constds Constes
        
        if sum(strcmp(chanlabel,{'MEG' 'MEGPLANAR' 'EEG'}))
            
            % get channels indices for specified modality
            chaninds = PatD.F{1}.indchantype(chanlabel);
            % get condition index
            coninds = PatD.F{1}.indtrial(con2plot{c});
            % get data for selected channels and current condition
            for i = 1:size(PatD.F,2)
                Patdata(i,:,:) = PatD.F{i}(chaninds,:,coninds);
                if rms
                    % get rms over channels
                    Patdata(i,:,:) = sqrt(mean(Patdata(i,:,:).^2,1));
                else
                    Patdata(i,:,:) = mean(Patdata(i,:,:),1);
                end
            end
            
            for i = 1:size(ConD.F,2)
                Condata(i,:,:) = ConD.F{i}(chaninds,:,coninds);
                if rms
                    % get rms over channels
                    Condata(i,:,:) = sqrt(mean(Condata(i,:,:).^2,1));
                else
                    Condata(i,:,:) = mean(Condata(i,:,:),1);
                end
            end
        end
        
        % specify name of dependent measure (and convert data to sensible
        % units)
        if sum(strcmp(chanlabel,'MEG')) || ~isempty(intersect(PatD.F{1}.indchantype('MEG'),PatD.F{1}.indchannel(chanlabel))) % MEGMAG
            measure = 'Amplitude (fT)';
            for i = 1:size(PatD.F,2)
                Patdata(i,:,:) = Patdata(i,:,:) * 1e15;
            end
            for i = 1:size(ConD.F,2)
                Condata(i,:,:) = Condata(i,:,:) * 1e15;
            end
        elseif sum(strcmp(chanlabel,'MEGPLANAR')) || ~isempty(intersect(PatD.F{1}.indchantype('MEGPLANAR'),PatD.F{1}.indchannel(chanlabel))) % MEGPLANAR
            measure = 'Amplitude (fT/m)';
            for i = 1:size(PatD.F,2)
                Patdata(i,:,:) = Patdata(i,:,:) * 1e15;
            end
            for i = 1:size(ConD.F,2)
                Condata(i,:,:) = Condata(i,:,:) * 1e15;
            end
        elseif sum(strcmp(chanlabel,'EEG')) || ~isempty(intersect(PatD.F{1}.indchantype('EEG'),PatD.F{1}.indchannel(chanlabel))) % EEG
            measure = 'Amplitude (\muV)';
            for i = 1:size(PatD.F,2)
                Patdata(i,:,:) = Patdata(i,:,:) * 1e6;
            end
            for i = 1:size(ConD.F,2)
                Condata(i,:,:) = Condata(i,:,:) * 1e6;
            end
        end
        
        %Compute overall means, stds and stes.
        Patmean = mean(Patdata,1);
        Patmean = squeeze(Patmean);
        Conmean = mean(Condata,1);
        Conmean = squeeze(Conmean);
        Patsd = std(Patdata,1);
        Consd = std(Condata,1);
        Patse = Patsd/sqrt(size(Patdata,1));
        Conse = Consd/sqrt(size(Condata,1));
        
        % plot
        subplot(ceil(sqrt(length(con2plot))),ceil(sqrt(length(con2plot))),c)
        plot(times(startSample:endSample),mean(Patmean(:,startSample:endSample),1),styles{1},'linewidth',2); hold all
        plot(times(startSample:endSample),mean(Conmean(:,startSample:endSample),1),styles{2},'linewidth',2); hold all
        plot(times(startSample:endSample),mean(Patmean(:,startSample:endSample),1) - mean(Conmean(:,startSample:endSample),1),styles{3},'linewidth',2); hold all
        
        %# vertical line
        hx = graph2d.constantline(0, 'LineStyle',':', 'Color',[0 0 0]);
        changedependvar(hx,'x');
        
        %# horizontal line
        hy = graph2d.constantline(0, 'LineStyle',':', 'Color',[0 0 0]);
        changedependvar(hy,'y');
        
        % if mean across time and conditions negative, reverse y axis
        if mean(mean(Patmean)) < 0
            set(gca,'YDir','Reverse');
        end
        set(gca,'FontSize',12,'FontWeight','Bold');
        xlabel('Time (ms)');
        ylabel(measure);
        title([modality{m} ': ' con2plot{c}]);
        legend('Patients', 'Controls', 'Contrast')
        
    end
    
end