%% Initialise path and subject definitions


%% Single subject ERP analysis (averaging over conditions)

% parameters
patientfile2plot = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_newICA/Grand Averages/patients_weighted_grandmean.mat';
controlfile2plot = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_newICA/Grand Averages/controls_weighted_grandmean.mat';
% file2plot = 'fmcfbMdspm8_run1_raw_ssst.mat';
modality = {'MEG' 'MEGPLANAR' 'EEG'};
plotRange = [-100 950]; % total time range to plot


%% Plot grand average ERPs for selected conditions

PatD = spm_eeg_load(patientfile2plot);
ConD = spm_eeg_load(controlfile2plot);

con2plot = PatD.conditions; %Assumes conditions the same for patients and controls
styles = {'-k' '-b' '-r'};

rms = 1;

times = PatD.time * 1000; % convert timescale to ms

% determine sample range to plot
[~, startSample] = min(abs(plotRange(1)-times));
[~, endSample] = min(abs(plotRange(2)-times));

cd '/group/language/data/thomascope/vespa/output/sensorpower' %change to directory where figures will be stored

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
%                 Patdata = sqrt(nanmean(Patdata.^2,1));
%                 Condata = sqrt(nanmean(Condata.^2,1));
%             else
%                 Patdata = nanmean(Patdata,1);
%                 Condata = nanmean(Condata,1);
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
%         % if nanmean across time and conditions negative, reverse y axis
%         if nanmean(nanmean(Patdata)) < 0
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
%

for m = 1:length(modality)
%for m = 3
    chanlabel = modality(m);
    %chanlabel = 'EEG056';
    % make figure
    figure;
    for c=1:length(con2plot)

        if sum(strcmp(chanlabel,{'MEG' 'MEGPLANAR' 'EEG'}))

            % get channels indices for specified modality
            chaninds = PatD.indchantype(chanlabel);
            % get condition index
            coninds = PatD.indtrial(con2plot{c});
            % get data for selected channels and current condition
            Patdata = PatD(chaninds,:,coninds);
            Condata = ConD(chaninds,:,coninds);
            if rms
                % get rms over channels
                Patdata = sqrt(nanmean(Patdata.^2,1));
                Condata = sqrt(nanmean(Condata.^2,1));
            else
                Patdata = nanmean(Patdata,1);
                Condata = nanmean(Condata,1);
            end

        else %if wanting to plot a single channel only

            % get channel indices
            chaninds = PatD.indchannel(chanlabel);
            % get condition index
            conind = PatD.indtrial(con2plot{c});
            % get data for selected channels and current condition
            Patdata = PatD(chaninds,:,conind);
            Condata = ConD(chaninds,:,conind);

        end

        % specify name of dependent measure (and convert data to sensible
        % units)
        if sum(strcmp(chanlabel,'MEG')) || ~isempty(intersect(PatD.indchantype('MEG'),PatD.indchannel(chanlabel))) % MEGMAG
            measure = 'Amplitude (fT)';
            Patdata = Patdata * 1;
            Condata = Condata * 1;
        elseif sum(strcmp(chanlabel,'MEGPLANAR')) || ~isempty(intersect(PatD.indchantype('MEGPLANAR'),PatD.indchannel(chanlabel))) % MEGPLANAR
            measure = 'Amplitude (fT/m)';
            Patdata = Patdata * 1e3;
            Condata = Condata * 1e3;
        elseif sum(strcmp(chanlabel,'EEG')) || ~isempty(intersect(PatD.indchantype('EEG'),PatD.indchannel(chanlabel))) % EEG
            measure = 'Amplitude (\muV)';
            Patdata = Patdata * 1;
            Condata = Condata * 1;
        end


        % plot
        subplot(ceil(sqrt(length(con2plot))),ceil(sqrt(length(con2plot))),c)
        plot(times(startSample:endSample),Patdata(:,startSample:endSample),styles{1},'linewidth',2); hold all
        plot(times(startSample:endSample),Condata(:,startSample:endSample),styles{2},'linewidth',2); hold all
        %plot(times(startSample:endSample),Patdata(:,startSample:endSample) - Condata(:,startSample:endSample),styles{3},'linewidth',2); hold all

        %# vertical line
        hx = graph2d.constantline(0, 'LineStyle',':', 'Color',[0 0 0]);
        changedependvar(hx,'x');

        %# horizontal line
        hy = graph2d.constantline(0, 'LineStyle',':', 'Color',[0 0 0]);
        changedependvar(hy,'y');

        % if nanmean across time and conditions negative, reverse y axis
        if nanmean(nanmean(Patdata)) < 0
            set(gca,'YDir','Reverse');
        end
        set(gca,'FontSize',12,'FontWeight','Bold');
        xlabel('Time (ms)');
        ylabel(measure);
        title([modality{m} ': ' con2plot{c}]);
        %legend('Patients', 'Controls', 'Contrast')
        legend('Patients', 'Controls')
        
        saveas(gcf, sprintf(['Overall plots for %s'],char(chanlabel)), 'fig')
        saveas(gcf, sprintf(['Overall plots for %s'],char(chanlabel)), 'tif')
        saveas(gcf, sprintf(['Overall plots for %s'],char(chanlabel)), 'jpg')
 
    end

end


%% Plot bar graph of signal (sensor space) for congruency
% NOTE: need to alter code to exclude plotting subjects with bad channels

% specify what to plot

% all time windows
%chanlabels = {'MEG0132'};
%chanlabels = {'MEGPLANAR'};
all_chanlabels = {'MEG0132'; 'MEG0341'; 'MEG0211'; 'EEG031'; 'EEG056';'EEG019'};
for chanset = 1:length(all_chanlabels)
    chanlabels = all_chanlabels{chanset};
    
    windows = [90 130; 180 240; 270 420; 450 700;];
    panels = {'Controls' 'Patients'}; % Slowest rotating factor (or title)...
    ticks = {'90-130ms'; '180-240ms'; '270-420ms'; '450-700ms'}; % ...next slowest...
    leg = {'Match' 'MisMatch'}; % CURRENTLY ONLY WORKS FOR THESE: {'Match' 'MisMatch'} {'Clear' 'Unclear'}
    legcolourkey = ['r' 'b'];
    legcolours = [];
    for i = 1:length(ticks)
        legcolours = [legcolours legcolourkey];
    end
    
    % style of text
    titlesize = 14;
    titleweight = 'Bold';
    axessize = 12;
    axesweight = 'Bold';
    
    % set max and min data points for y-axis limits
    ylim = [];
    
    controldata = [];
    patientdata = [];
    
    for s=1:length(subjects)
        
        fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
        
        file = dir([pathstem subjects{s} '/fmcfbMdeMr*.mat']);
        %file = dir([pathstem subjects{s} '/cfm*.mat']);
        filename = [pathstem subjects{s} '/' file.name];
        D = spm_eeg_load(filename);
        
        tmp = [];
        for t=1:length(ticks)
            
            for l=1:length(leg)
                
                if sum(strcmp(chanlabels,{'MEG' 'MEGPLANAR' 'EEG'}))
                    chaninds = D.indchantype(chanlabels);
                else
                    chaninds = D.indchannel(chanlabels);
                end
                %             if size(windows,1) > 1  % extract data from specified channel, time window and condition
                %                 dataselect = D(chanlabels{t},windows(t,:)/1000,leg{l});
                %             elseif isempty(leg)
                %                 dataselect = D(chanlabels{t},windows/1000,ticks{t});
                %             else
                %                 dataselect = D(chanlabels{t},windows/1000,leg{l});
                %             end
                
                [startSample startSample] = min(abs(windows(t,1)-times));
                [endSample endSample] = min(abs(windows(t,2)-times));
                
                if sum(strcmp(leg, {'Match' 'MisMatch'}))==2;
                    dataselect = D(chaninds,[startSample:endSample],[3-l,5-l,7-l]);
                elseif sum(strcmp(leg, {'Clear' 'Unclear'}))==2;
                    dataselect = D(chaninds,[startSample:endSample],[9-4*l,10-4*l]);
                else
                    error('Not a clear contrast')
                end
                
                dataAvg = nanmean(dataselect); % average over time
                tmp = [tmp dataAvg]; % store data
                
            end
            
        end
        
        if group(s) == 1
            fprintf([ '\nIdentified as a control. \n' ]);
            controldata = [controldata; tmp];
            
            
        elseif group(s) == 2
            fprintf([ '\nIdentified as a patient. \n' ]);
            patientdata = [patientdata; tmp];
        end
        
    end
    
    datatotal = [controldata; patientdata];
    
    % 1) Work out number of panels and conditions 2) Determine xtick spacing so
    % that xlabels are appropriately positioned
    npanels = length(panels);
    nticks = length(ticks);
    if ~isempty(leg{1})
        nticks = nticks * length(leg);
        xspacing = (length(leg)+1)/2:length(leg):nticks;
    else
        xspacing = [1:length(ticks)];
    end
    
    % Replicate color cell array if number of elements less than number of conditions per panel
    ncolours = length(legcolours);
    if ncolours < nticks
        legcolours = repmat(legcolours,1,nticks/ncolours);
    end
    
    % specify name of dependent measure (and convert data to sensible units)
    if ~isempty(intersect(D.indchantype('MEG'),D.indchannel(chanlabels))) % MEGMAG
        measure = 'Amplitude (fT)';
        datatotal = datatotal * 1;
    elseif ~isempty(intersect(D.indchantype('MEGPLANAR'),D.indchannel(chanlabels))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        datatotal = datatotal * 1e3;
    elseif ~isempty(intersect(D.indchantype('EEG'),D.indchannel(chanlabels))) % EEG
        measure = 'Amplitude (\muV)';
        datatotal = datatotal * 1;
    end
    
    % remove between subject variability separately for each group
    lastcontrol = length(find(group==1));
    figure
    for p = 1:2
        if p == 1
            data = datatotal(1:lastcontrol,:,:);
        elseif p == 2
            data = datatotal(lastcontrol+1:end,:,:);
        end
        if size(windows,1) == 1 % if only one time window
            nanmeans_all_conditions = nannanmean(data,2);
            grand_nanmean = nannanmean(nanmeans_all_conditions);
            adjustment_factors = grand_nanmean - nanmeans_all_conditions;
            adjustment_factors = repmat(adjustment_factors,1,nticks);
            data_adj = data + adjustment_factors;
        else % else more than one time window,remove btwn subj variability separately for each time-window
            count = 0;
            data_adj = [];
            for t=1:length(ticks)
                tmp = [];
                for l=1:length(leg)
                    count = count + 1;
                    tmp(:,l) = data(:,count);
                end
                nanmeans_all_conditions = nannanmean(tmp,2);
                grand_nanmean = nannanmean(nanmeans_all_conditions);
                adjustment_factors = grand_nanmean - nanmeans_all_conditions;
                adjustment_factors = repmat(adjustment_factors,1,length(leg));
                data_adj = [data_adj [tmp+adjustment_factors] ];
            end
        end
        
        % Calculate nanmeans and sems
        nanmeans = nanmean(data_adj,1);
        sems = std(data_adj,0,1)/sqrt(length(subjects));
        
        % DON'T reshape data according to number of panels
        nanmeans = reshape(nanmeans,nticks,1).';
        sems = reshape(sems,nticks,1).';
        
        subplot(1,npanels,p);
        
        hold on
        
        for t=1:nticks % plot bar graph
            bar(t,nanmeans(1,t),char(legcolours(t)),'LineWidth',2);
        end
        
        for t=1:nticks % add error bars
            if nanmeans(1,t) < 0
                errorhandle = errorbar(t,nanmeans(1,t),sems(1,t),0,'k','LineWidth',2);
            else
                errorhandle = errorbar(t,nanmeans(1,t),0,sems(1,t),'k','LineWidth',2);
            end
            errorbar_tick(errorhandle);
        end
        
        % Annotate
        set(gca,'FontSize',axessize,'FontWeight',axesweight);
        if ~isempty(ylim)
            set(gca,'YLim',ylim);
        end
        if nanmean(nanmeans(1,:)) < 0 % if nanmean across conditions negative, reverse y axis
            set(gca,'YDir','Reverse');
        end
        ylabel(measure);
        set(gca,'XLim',[0 nticks+1]);
        set(gca,'XTick',xspacing);
        set(gca,'XTickLabel',ticks);
        title(panels{p},'FontSize',titlesize,'FontWeight',titleweight);
        
        if ~isempty(leg{1})
            legend(gca,leg,'Location','NorthWest'); % add legend (if appropriate)
        end
        
        if p == 1
            controlnanmeans = nanmeans;
            controlsems = sems;
        elseif p == 2
            patientnanmeans = nanmeans;
            patientsems = sems;
        end
        
    end
    hold off
    
    figure
    set(gcf,'position',[100,100,1200,800])
    barweb(reshape(patientnanmeans,2,4)',reshape(patientsems,2,4)',[],{'90-130ms'; '180-240ms'; '270-420ms'; '450-700ms'},sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Match','Mismatch'}) ;
    legend('Match','Mismatch','location','NorthWest');
    if nanmean(controlnanmeans) < 0
    set(gca,'YDir','Reverse');
    end
    saveas(gcf,sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'fig');
    saveas(gcf,sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'tif');
    saveas(gcf,sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'jpg');
    
    figure
    set(gcf,'position',[100,100,1200,800])
    barweb(reshape(controlnanmeans,2,4)',reshape(controlsems,2,4)',[],{'90-130ms'; '180-240ms'; '270-420ms'; '450-700ms'},sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Match','Mismatch'}) ;
    legend('Match','Mismatch','location','NorthWest');
    if nanmean(controlnanmeans) < 0
    set(gca,'YDir','Reverse');
    end
    saveas(gcf,sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'fig');
    saveas(gcf,sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'tif');
    saveas(gcf,sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'jpg');
    
    
    % Now do the calculation by channel for early timewindows
    if size(windows,1) == 4
        datatotal_save = datatotal;
        ticks = {'4 Channels';'8 Channels';'16 Channels';};
        for timewin = 1:2
            thisdata = datatotal_save(:,3+timewin*2:4+timewin*2,:);
            datatotal = reshape(thisdata,size(thisdata,1),size(thisdata,2)*size(thisdata,3));
            nticks = length(ticks);
            if ~isempty(leg{1})
                nticks = nticks * length(leg);
                xspacing = (length(leg)+1)/2:length(leg):nticks;
            else
                xspacing = [1:length(ticks)];
            end
            
            % Replicate color cell array if number of elements less than number of conditions per panel
            ncolours = length(legcolours);
            if ncolours < nticks
                legcolours = repmat(legcolours,1,nticks/ncolours);
            end
            figure
            for p = 1:2
                if p == 1
                    data = datatotal(1:lastcontrol,:,:);
                elseif p == 2
                    data = datatotal(lastcontrol+1:end,:,:);
                end
                if size(windows,1) == 1 % if only one time window
                    nanmeans_all_conditions = nannanmean(data,2);
                    grand_nanmean = nannanmean(nanmeans_all_conditions);
                    adjustment_factors = grand_nanmean - nanmeans_all_conditions;
                    adjustment_factors = repmat(adjustment_factors,1,nticks);
                    data_adj = data + adjustment_factors;
                else % else more than one time window,remove btwn subj variability separately for each time-window
                    count = 0;
                    data_adj = [];
                    for t=1:length(ticks)
                        tmp = [];
                        for l=1:length(leg)
                            count = count + 1;
                            tmp(:,l) = data(:,count);
                        end
                        nanmeans_all_conditions = nannanmean(tmp,2);
                        grand_nanmean = nannanmean(nanmeans_all_conditions);
                        adjustment_factors = grand_nanmean - nanmeans_all_conditions;
                        adjustment_factors = repmat(adjustment_factors,1,length(leg));
                        data_adj = [data_adj [tmp+adjustment_factors] ];
                    end
                end
                
                % Calculate nanmeans and sems
                nanmeans = nanmean(data_adj,1);
                sems = std(data_adj,0,1)/sqrt(length(subjects));
                
                % DON'T reshape data according to number of panels
                nanmeans = reshape(nanmeans,nticks,1).';
                sems = reshape(sems,nticks,1).';
                
                subplot(1,npanels,p);
                
                hold on
                
                for t=1:nticks % plot bar graph
                    bar(t,nanmeans(1,t),char(legcolours(t)),'LineWidth',2);
                end
                
                for t=1:nticks % add error bars
                    if nanmeans(1,t) < 0
                        errorhandle = errorbar(t,nanmeans(1,t),sems(1,t),0,'k','LineWidth',2);
                    else
                        errorhandle = errorbar(t,nanmeans(1,t),0,sems(1,t),'k','LineWidth',2);
                    end
                    errorbar_tick(errorhandle);
                end
                
                % Annotate
                set(gca,'FontSize',axessize,'FontWeight',axesweight);
                if ~isempty(ylim)
                    set(gca,'YLim',ylim);
                end
                if nanmean(nanmeans(1,:)) < 0 % if nanmean across conditions negative, reverse y axis
                    set(gca,'YDir','Reverse');
                end
                ylabel(measure);
                set(gca,'XLim',[0 nticks+1]);
                set(gca,'XTick',xspacing);
                set(gca,'XTickLabel',ticks);
                title(panels{p},'FontSize',titlesize,'FontWeight',titleweight);
                
                if ~isempty(leg{1})
                    legend(gca,leg,'Location','NorthWest'); % add legend (if appropriate)
                end
                
                if p == 1
                    controlnanmeans = nanmeans;
                    controlsems = sems;
                elseif p == 2
                    patientnanmeans = nanmeans;
                    patientsems = sems;
                end
                
            end
            hold off
            
            figure
            set(gcf,'position',[100,100,1200,800])
            barweb(reshape(patientnanmeans,2,3)',reshape(patientsems,2,3)',[],ticks,sprintf(['Patient response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Match','Mismatch'}) ;
            legend('Match','Mismatch','location','NorthWest');
            if nanmean(controlnanmeans) < 0
                set(gca,'YDir','Reverse');
            end
            saveas(gcf,sprintf(['Patient response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'fig');
            saveas(gcf,sprintf(['Patient response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'tif');
            saveas(gcf,sprintf(['Patient response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'jpg');            
           
            figure
            set(gcf,'position',[100,100,1200,800])
            barweb(reshape(controlnanmeans,2,3)',reshape(controlsems,2,3)',[],ticks,sprintf(['Control response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Match','Mismatch'}) ;
            legend('Match','Mismatch','location','NorthWest');
            if nanmean(controlnanmeans) < 0
                set(gca,'YDir','Reverse');
            end
            saveas(gcf,sprintf(['Control response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'fig');
            saveas(gcf,sprintf(['Control response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'tif');
            saveas(gcf,sprintf(['Control response by sensory detail at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'jpg');
        end
        
        
    end
end

%% Plot bar graph of signal (sensor space) for clarity comparison
% NOTE: need to alter code to exclude plotting subjects with bad channels

% specify what to plot

% all time windows
%chanlabels = {'MEG0132'};
%chanlabels = {'MEGPLANAR'};
all_chanlabels = {'MEG0243'; 'MEG1611';'EEG019';'MEG1311'};
for chanset = 1:length(all_chanlabels)
    chanlabels = all_chanlabels{chanset};
    
    windows = [90 130; 180 240; 270 420; 450 700;];
    panels = {'Controls' 'Patients'}; % Slowest rotating factor (or title)...
    ticks = {'90-130ms'; '180-240ms'; '270-420ms'; '450-700ms'}; % ...next slowest...
    leg = {'Clear' 'Unclear'}; % CURRENTLY ONLY WORKS FOR THESE: {'Match' 'MisMatch'} {'Clear' 'Unclear'}
    legcolourkey = ['r' 'b'];
    legcolours = [];
    for i = 1:length(ticks)
        legcolours = [legcolours legcolourkey];
    end
    
    % style of text
    titlesize = 14;
    titleweight = 'Bold';
    axessize = 12;
    axesweight = 'Bold';
    
    % set max and min data points for y-axis limits
    ylim = [];
    
    controldata = [];
    patientdata = [];
    
    for s=1:length(subjects)
        
        fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
        
        file = dir([pathstem subjects{s} '/fmcfbMdeMr*.mat']);
        %file = dir([pathstem subjects{s} '/cfm*.mat']);
        filename = [pathstem subjects{s} '/' file.name];
        D = spm_eeg_load(filename);
        
        tmp = [];
        for t=1:length(ticks)
            
            for l=1:length(leg)
                
                if sum(strcmp(chanlabels,{'MEG' 'MEGPLANAR' 'EEG'}))
                    chaninds = D.indchantype(chanlabels);
                else
                    chaninds = D.indchannel(chanlabels);
                end
                %             if size(windows,1) > 1  % extract data from specified channel, time window and condition
                %                 dataselect = D(chanlabels{t},windows(t,:)/1000,leg{l});
                %             elseif isempty(leg)
                %                 dataselect = D(chanlabels{t},windows/1000,ticks{t});
                %             else
                %                 dataselect = D(chanlabels{t},windows/1000,leg{l});
                %             end
                
                [startSample startSample] = min(abs(windows(t,1)-times));
                [endSample endSample] = min(abs(windows(t,2)-times));
                
                if sum(strcmp(leg, {'Match' 'MisMatch'}))==2;
                    dataselect = D(chaninds,[startSample:endSample],[3-l,5-l,7-l]);
                elseif sum(strcmp(leg, {'Clear' 'Unclear'}))==2;
                    dataselect = D(chaninds,[startSample:endSample],[9-4*l,10-4*l]);
                else
                    error('Not a clear contrast')
                end
                
                dataAvg = nanmean(dataselect); % average over time
                tmp = [tmp dataAvg]; % store data
                
            end
            
        end
        
        if group(s) == 1
            fprintf([ '\nIdentified as a control. \n' ]);
            controldata = [controldata; tmp];
            
            
        elseif group(s) == 2
            fprintf([ '\nIdentified as a patient. \n' ]);
            patientdata = [patientdata; tmp];
        end
        
    end
    
    datatotal = [controldata; patientdata];
    
    % 1) Work out number of panels and conditions 2) Determine xtick spacing so
    % that xlabels are appropriately positioned
    npanels = length(panels);
    nticks = length(ticks);
    if ~isempty(leg{1})
        nticks = nticks * length(leg);
        xspacing = (length(leg)+1)/2:length(leg):nticks;
    else
        xspacing = [1:length(ticks)];
    end
    
    % Replicate color cell array if number of elements less than number of conditions per panel
    ncolours = length(legcolours);
    if ncolours < nticks
        legcolours = repmat(legcolours,1,nticks/ncolours);
    end
    
    % specify name of dependent measure (and convert data to sensible units)
    if ~isempty(intersect(D.indchantype('MEG'),D.indchannel(chanlabels))) % MEGMAG
        measure = 'Amplitude (fT)';
        datatotal = datatotal * 1;
    elseif ~isempty(intersect(D.indchantype('MEGPLANAR'),D.indchannel(chanlabels))) % MEGPLANAR
        measure = 'Amplitude (fT/m)';
        datatotal = datatotal * 1e3;
    elseif ~isempty(intersect(D.indchantype('EEG'),D.indchannel(chanlabels))) % EEG
        measure = 'Amplitude (\muV)';
        datatotal = datatotal * 1;
    end
    
    % remove between subject variability separately for each group
    lastcontrol = length(find(group==1));
    figure
    for p = 1:2
        if p == 1
            data = datatotal(1:lastcontrol,:,:);
        elseif p == 2
            data = datatotal(lastcontrol+1:end,:,:);
        end
        if size(windows,1) == 1 % if only one time window
            nanmeans_all_conditions = nannanmean(data,2);
            grand_nanmean = nannanmean(nanmeans_all_conditions);
            adjustment_factors = grand_nanmean - nanmeans_all_conditions;
            adjustment_factors = repmat(adjustment_factors,1,nticks);
            data_adj = data + adjustment_factors;
        else % else more than one time window,remove btwn subj variability separately for each time-window
            count = 0;
            data_adj = [];
            for t=1:length(ticks)
                tmp = [];
                for l=1:length(leg)
                    count = count + 1;
                    tmp(:,l) = data(:,count);
                end
                nanmeans_all_conditions = nannanmean(tmp,2);
                grand_nanmean = nannanmean(nanmeans_all_conditions);
                adjustment_factors = grand_nanmean - nanmeans_all_conditions;
                adjustment_factors = repmat(adjustment_factors,1,length(leg));
                data_adj = [data_adj [tmp+adjustment_factors] ];
            end
        end
        
        % Calculate nanmeans and sems
        nanmeans = nanmean(data_adj,1);
        sems = std(data_adj,0,1)/sqrt(length(subjects));
        
        % DON'T reshape data according to number of panels
        nanmeans = reshape(nanmeans,nticks,1).';
        sems = reshape(sems,nticks,1).';
        
        subplot(1,npanels,p);
        
        hold on
        
        for t=1:nticks % plot bar graph
            bar(t,nanmeans(1,t),char(legcolours(t)),'LineWidth',2);
        end
        
        for t=1:nticks % add error bars
            if nanmeans(1,t) < 0
                errorhandle = errorbar(t,nanmeans(1,t),sems(1,t),0,'k','LineWidth',2);
            else
                errorhandle = errorbar(t,nanmeans(1,t),0,sems(1,t),'k','LineWidth',2);
            end
            errorbar_tick(errorhandle);
        end
        
        % Annotate
        set(gca,'FontSize',axessize,'FontWeight',axesweight);
        if ~isempty(ylim)
            set(gca,'YLim',ylim);
        end
        if nanmean(nanmeans(1,:)) < 0 % if nanmean across conditions negative, reverse y axis
            set(gca,'YDir','Reverse');
        end
        ylabel(measure);
        set(gca,'XLim',[0 nticks+1]);
        set(gca,'XTick',xspacing);
        set(gca,'XTickLabel',ticks);
        title(panels{p},'FontSize',titlesize,'FontWeight',titleweight);
        
        if ~isempty(leg{1})
            legend(gca,leg,'Location','NorthWest'); % add legend (if appropriate)
        end
        
        if p == 1
            controlnanmeans = nanmeans;
            controlsems = sems;
        elseif p == 2
            patientnanmeans = nanmeans;
            patientsems = sems;
        end
        
    end
    hold off
    
    figure
    set(gcf,'position',[100,100,1200,800])
    barweb(reshape(patientnanmeans,2,4)',reshape(patientsems,2,4)',[],{'90-130ms'; '180-240ms'; '270-420ms'; '450-700ms'},sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Clear','Unclear'}) ;
    legend('Clear','Unclear','location','NorthWest');
    if nanmean(controlnanmeans) < 0
        set(gca,'YDir','Reverse');
    end
    saveas(gcf,sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'fig');
    saveas(gcf,sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'tif');
    saveas(gcf,sprintf(['Patient response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'jpg');
    
    
    figure
    set(gcf,'position',[100,100,1200,800])
    barweb(reshape(controlnanmeans,2,4)',reshape(controlsems,2,4)',[],{'90-130ms'; '180-240ms'; '270-420ms'; '450-700ms'},sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Clear','Unclear'}) ;
    legend('Clear','Unclear','location','NorthWest');
    if nanmean(controlnanmeans) < 0
        set(gca,'YDir','Reverse');
    end
    saveas(gcf,sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'fig');
    saveas(gcf,sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'tif');
    saveas(gcf,sprintf(['Control response by time at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),'jpg');
    
%     
%     % Now do the calculation by channel for relevant timewindows
%     if size(windows,1) == 4
%         datatotal_save = datatotal;
%         ticks = {'4 Channels';'8 Channels';'16 Channels';};
%         for timewin = 1:3
%             thisdata = datatotal_save(:,-1+timewin*2:0+timewin*2,:);
%             datatotal = reshape(thisdata,size(thisdata,1),size(thisdata,2)*size(thisdata,3));
%             nticks = length(ticks);
%             if ~isempty(leg{1})
%                 nticks = nticks * length(leg);
%                 xspacing = (length(leg)+1)/2:length(leg):nticks;
%             else
%                 xspacing = [1:length(ticks)];
%             end
%             
%             % Replicate color cell array if number of elements less than number of conditions per panel
%             ncolours = length(legcolours);
%             if ncolours < nticks
%                 legcolours = repmat(legcolours,1,nticks/ncolours);
%             end
%             figure
%             for p = 1:2
%                 if p == 1
%                     data = datatotal(1:lastcontrol,:,:);
%                 elseif p == 2
%                     data = datatotal(lastcontrol+1:end,:,:);
%                 end
%                 if size(windows,1) == 1 % if only one time window
%                     nanmeans_all_conditions = nannanmean(data,2);
%                     grand_nanmean = nannanmean(nanmeans_all_conditions);
%                     adjustment_factors = grand_nanmean - nanmeans_all_conditions;
%                     adjustment_factors = repmat(adjustment_factors,1,nticks);
%                     data_adj = data + adjustment_factors;
%                 else % else more than one time window,remove btwn subj variability separately for each time-window
%                     count = 0;
%                     data_adj = [];
%                     for t=1:length(ticks)
%                         tmp = [];
%                         for l=1:length(leg)
%                             count = count + 1;
%                             tmp(:,l) = data(:,count);
%                         end
%                         nanmeans_all_conditions = nannanmean(tmp,2);
%                         grand_nanmean = nannanmean(nanmeans_all_conditions);
%                         adjustment_factors = grand_nanmean - nanmeans_all_conditions;
%                         adjustment_factors = repmat(adjustment_factors,1,length(leg));
%                         data_adj = [data_adj [tmp+adjustment_factors] ];
%                     end
%                 end
%                 
%                 % Calculate nanmeans and sems
%                 nanmeans = nanmean(data_adj,1);
%                 sems = std(data_adj,0,1)/sqrt(length(subjects));
%                 
%                 % DON'T reshape data according to number of panels
%                 nanmeans = reshape(nanmeans,nticks,1).';
%                 sems = reshape(sems,nticks,1).';
%                 
%                 subplot(1,npanels,p);
%                 
%                 hold on
%                 
%                 for t=1:nticks % plot bar graph
%                     bar(t,nanmeans(1,t),char(legcolours(t)),'LineWidth',2);
%                 end
%                 
%                 for t=1:nticks % add error bars
%                     if nanmeans(1,t) < 0
%                         errorhandle = errorbar(t,nanmeans(1,t),sems(1,t),0,'k','LineWidth',2);
%                     else
%                         errorhandle = errorbar(t,nanmeans(1,t),0,sems(1,t),'k','LineWidth',2);
%                     end
%                     errorbar_tick(errorhandle);
%                 end
%                 
%                 % Annotate
%                 set(gca,'FontSize',axessize,'FontWeight',axesweight);
%                 if ~isempty(ylim)
%                     set(gca,'YLim',ylim);
%                 end
%                 if nanmean(nanmeans(1,:)) < 0 % if nanmean across conditions negative, reverse y axis
%                     set(gca,'YDir','Reverse');
%                 end
%                 ylabel(measure);
%                 set(gca,'XLim',[0 nticks+1]);
%                 set(gca,'XTick',xspacing);
%                 set(gca,'XTickLabel',ticks);
%                 title(panels{p},'FontSize',titlesize,'FontWeight',titleweight);
%                 
%                 if ~isempty(leg{1})
%                     legend(gca,leg,'Location','NorthWest'); % add legend (if appropriate)
%                 end
%                 
%                 if p == 1
%                     controlnanmeans = nanmeans;
%                     controlsems = sems;
%                 elseif p == 2
%                     patientnanmeans = nanmeans;
%                     patientsems = sems;
%                 end
%                 
%             end
%             hold off
%             
%             figure
%             set(gcf,'position',[100,100,1200,800])
%             barweb(reshape(patientnanmeans,2,3)',reshape(patientsems,2,3)',[],ticks,sprintf(['Patient response at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Clear','Unclear'});
%             legend('Clear','Unclear','location','NorthWest');
%             if nanmean(controlnanmeans) < 0
%             set(gca,'YDir','Reverse');
%             end
%             
%             figure
%             set(gcf,'position',[100,100,1200,800])
%             barweb(reshape(controlnanmeans,2,3)',reshape(controlsems,2,3)',[],ticks,sprintf(['Control response at %s, a sensor of type %s'],chanlabels, char(D.chantype(chaninds))),[],'fT',[],[],{'Clear','Unclear',}) ;
%             legend('Clear','Unclear','location','NorthWest');
%             if nanmean(controlnanmeans) < 0
%             set(gca,'YDir','Reverse');
%             end
%         end
        
        
%     end
end

%% Plot grand average ERP topographies across conditions (fieldtrip version)

% parameters

% modality = 'MEG';
% con2plot = {'Post-Pre'};
% %windows = [88 88; 380 380; 500 500; 644 644];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-5e-14 5e-14];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_test_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Post-Pre.img'};
% p = 1;
% df = [1 95];

% modality = 'MEGPLANAR';
% con2plot = {'Post-Pre'};
% %windows = [88 88; 240 240; 700 700;];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-4e-13 4e-13];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_test_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Post-Pre.img'};
% p = 1;
% df = [1 95];

% modality = 'EEG';
% con2plot = {'Post-Pre'};
% %windows = [84 84; 196 196; 380 380; 488 488];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-1.5e-6 1.5e-6];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_test_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Post-Pre.img'};
% p = 1;
% df = [1 95];

% modality = 'MEG';
% con2plot = {'Train_Match-Mismatch'};
% %windows = [504 504; 580 580; 604 604];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-7e-14 7e-14];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Matching-Mismatching.img'};
% p = 1;
% df = [1 95];

% modality = 'MEGPLANAR';
% con2plot = {'Train_Match-Mismatch'};
% windows = [312 792; 232 800;];
% highlightchannel = {};
% limits = [-.75e-12 .75e-12];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Matching-Mismatching_51_24_484.nii' 'Matching-Mismatching_-47_8_572.nii'};
% p = 1;
% df = [1 95];

modality = 'EEG';
con2plot = {'Train_Match-Mismatch'};
windows = [396 760; 208 800; 148 800;];
highlightchannel = {};
limits = [-2e-6 2e-6];
imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
imgs = {'Matching-Mismatching_60_-25_588.nii' 'Matching-Mismatching_-4_-19_644.nii' 'Matching-Mismatching_-51_-9_568.nii'};
p = 1;
df = [1 95];

% modality = 'MEG';
% con2plot = {'Train_12-3'};
% %windows = [128 128; 712 712; 788 788];
% windows = [80 120; 170 230; 260 420; 450 700;];
% highlightchannel = {};
% limits = [-3e-14 3e-14];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Sensory_detail.img'};
% p = 1;
% df = [2 95];

% modality = 'MEGPLANAR';
% con2plot = {'Train_12-3'};
% windows = [524 800; 232 332;];
% highlightchannel = {};
% limits = [-.75e-12 .75e-12];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Sensory_detail_26_18_748.nii' 'Sensory_detail_-47_8_256.nii'};
% p = 1;
% df = [2 95];

% modality = 'EEG';
% con2plot = {'Train_12-3'};
% windows = [604 744; 556 632; 548 752; 108 204;];
% highlightchannel = {};
% limits = [-2e-6 2e-6];
% imgdir = '/imaging/mlr/users/tc02/vespa/stats_train_learning_covariate_extraSmooth_sm_trial*/';
% imgs = {'Sensory_detail_21_50_676.nii' 'Sensory_detail_30_-46_612.nii' 'Sensory_detail_55_18_636.nii' 'Sensory_detail_-4_-25_168.nii'};
% p = 1;
% df = [2 95];

nconditions = length(con2plot);
nwindows = size(windows,1);

% get SPM data and convert into fieldtrip format
D = spm_eeg_load([pathstem 'gwpcfmcfbMdspm8_01_preTest_raw_ssst.mat']); % load grand average
data_ft = D.fttimelock; % convert to fieldtrip format
data_ft.avg = data_ft.trial;
data_ft.time = data_ft.time*1000;

% setup channel layout for ft_topoplotER
cfg = [];
switch modality
    case 'MEG'
        chaninds = D.meegchannels('MEG');
        cfg.layout.pos = D.coor2D(chaninds)';
        cfg.layout.label = D.chanlabels(chaninds);
    case 'MEGPLANAR'
        chaninds = spm_eeg_grad_pairs(D);
        chaninds = chaninds(:,1);
        cfg.layout.pos = D.coor2D(chaninds)';
        cfg.layout.label = D.chanlabels(chaninds);
    case 'EEG'
        chaninds = D.meegchannels('EEG');
        cfg.layout.pos = D.coor2D(chaninds)';
        cfg.layout.label = D.chanlabels(chaninds);
end

% topography appearance
cfg.marker = 'off';
%cfg.comment = 'no';

% topography limits
if isempty(limits)
    cfg.zlim = 'maxabs';
else % else use manually set value
    cfg.zlim = limits;
end

figure; count = 0;
for c=1:nconditions
    
    for w=1:nwindows
        
        count = count + 1;
        subplot(nconditions,nwindows,count);
        
        cfg.xlim = windows(w,:);
        cfg.trials = D.pickconditions(con2plot{c});
        if isempty(cfg.trials)
            error('Error locating condition. Check spelling or try different MEEG file');
        end
        
        if ~isempty(highlightchannel)
            cfg.highlight = 'on';
            cfg.highlightchannel = highlightchannel{w};
            cfg.highlightsize = 9;
            cfg.highlightcolor = [1 1 1];
            cfg.highlightsymbol = 'o';
        else
            cfg.highlight = 'off';
            cfg.highlightchannel = [];
            cfg.highlightsize = [];
            cfg.highlightcolor = [];
            cfg.highlightsymbol = [];
        end
        
        if ~isempty(imgdir)
            statsdir = [imgdir modality '/'];
            V = spm_vol([statsdir imgs{count}]);
            data_img = spm_read_vols(V);
            startsample = nearestpoint(windows(w,1),data_ft.time);
            endsample = nearestpoint(windows(w,2),data_ft.time);
            %data_img = nannanmean(data_img(:,:,startsample:endsample),3);
            if ndims(data_img) > 2 % if image has time dimension, calculate maximum intensity projection over time
                startsample = nearestpoint(windows(w,1),data_ft.time);
                endsample = nearestpoint(windows(w,2),data_ft.time);
                data_img = max(data_img(:,:,startsample:endsample),[],3);
            end
            [Cel, Cind] = spm_eeg_locate_channels(D, size(data_img,1), 1);
            [Cind Cind_ind] = intersect(Cind,D.meegchannels(modality));
            Cel = Cel(Cind_ind,:);
            
            load([statsdir 'SPM.mat']);
            if p < 1
                thresh = spm_uc_RF(p,df,'F',SPM.xVol.R,1);
            else
                thresh = 0;
            end
            [x y] = find(data_img>thresh);
            threshlabels = {};
            for i=1:length(x)
                [discard1 Cel_ind discard2] = spm_XYZreg('NearestXYZ',[x(i) y(i) 1],[Cel'; ones(1,size(Cel))]);
                threshlabels = [D.chanlabels(Cind(Cel_ind)); threshlabels];
            end
            threshlabels = unique(threshlabels);
            
            cfg.highlight = {cfg.highlight 'on'};
            cfg.highlightchannel = {cfg.highlightchannel threshlabels};
            cfg.highlightsize = {cfg.highlightsize 6};
            cfg.highlightcolor = {cfg.highlightcolor [0 0 0]};
            cfg.highlightsymbol = {cfg.highlightsymbol  '.'};
        end
        
        ft_topoplotER(cfg,data_ft);
        
    end
    
end

%% Display image source estimates over cortical mesh

% M-MM
% imgs = {
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0001.img';
%        };
%
% imgs2 = {
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0002.img';
%        };

% % 12-3ch
% imgs = {
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0001.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0001.img';
%        };
%
% imgs2 = {
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*_ttest/Source/spmT_0002.img';
%        };

% Positive
imgs = {
    '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t232_332_f1_40*_ttest/Source/spmT_0001.img';
    '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t148_232_f1_40*_ttest/Source/spmT_0001.img';
    };

% Negative
% imgs = {
%         '/imaging/mlr/users/tc02/vespa/stats_Train_12-3_cfmcfbMdspm8_01_preTest_raw_ssst_2_t108_204_f1_40*_ttest/Source/spmT_0002.img';
%         '/imaging/mlr/users/tc02/vespa/stats_Train_Match-Mismatch_cfmcfbMdspm8_01_preTest_raw_ssst_2_t232_800_f1_40*_ttest/Source/spmT_0002.img';
%       };

%cmap = 'hot';
%cmap2 = load('/imaging/es03/P3E1/colormap_black-blue-white.mat');
%cmap2 = cmap2.cmap;
cmap = colormap('jet');
cmap = cmap(end/2+1:end,:); % for positive
%cmap = cmap(end/2:-1:1,:); % for negative

%df = [1 100];
df = [1 20];
type = 't';
p = [0.05 0.001];
symmetrical = 0;

cfg.inflate = 5;
cfg.plots = [1 2];

for i=1:length(imgs)
    
    if ~isempty(p)
        if strcmp(type,'t')
            mini = spm_invTcdf(1-abs(p(1)),df);
            mini = mini(2);
            maxi = spm_invTcdf(1-abs(p(2)),df);
            maxi = maxi(2);
        elseif strcmp(type,'F')
            mini = spm_invFcdf(1-abs(p(1)),df);
            maxi = spm_invFcdf(1-abs(p(2)),df);
        end
        
        if p(1)>0
            cfg.colorscale = [mini maxi];
            cfg.colorscale2 = [mini maxi];
        else
            cfg.colorscale = [-mini maxi];
            cfg.colorscale2 = [mini maxi];
        end
    elseif symmetrical
        cfg.colorscale = 'symmetrical';
    else
        cfg.colorscale = [];
    end
    
    jp_spm8_surfacerender2_version_es(imgs{i},cmap,cfg);
    %jp_spm8_surfacerender2_version_es(imgs{i},cmap,cfg,imgs2{i},cmap2);
    
end

