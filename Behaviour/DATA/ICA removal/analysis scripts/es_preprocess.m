function es_preprocess(step,prevStep,p,pathstem,subjects,dates,blocksin,blocksout,rawpathstem,badeeg)

switch prevStep
    
    case 'maxfilter'
        prevStep = '*ssst.fif';    
    case 'convert'   
        prevStep = 'spm8*.mat';
    case 'downsample'   
        prevStep = 'd*.mat';
    case 'epoch'     
        prevStep = 'e*.mat';
    case 'merge'    
        prevStep = 'c*.mat';
    case 'rereference'     
        prevStep = 'M*.mat';
    case 'TF_power'
        prevStep = 'tf*.mat';
    case 'TF_phase'
        prevStep = 'tph*.mat';
    case 'TF_rescale'
        prevStep = 'r*.mat';
    case 'filter'     
        prevStep = 'f*.mat';
    case 'baseline'   
        prevStep = 'b*.mat';
    case 'average'
        prevStep = 'm*.mat';
    case 'weight'
        prevStep = 'w*.mat';
    case 'combineplanar'
        prevStep = 'p*.mat';
    case 'artefact'   
        prevStep = 'a*.mat';
    case 'blink'
        prevStep = 'clean*.mat';
    case 'image'
        prevStep = 'trial*.img';
    case 'smooth'
        prevStep = 'sm*.img';
    case 'firstlevel'
        prevStep = 't*.img';
        
end

switch step
    
    case 'erase'
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % main process
                delete(files(f).name);       
                if strfind(files(f).name,'spm8') % if spm8 file, delete .dat file (in addition to .mat file)     
                    datname = [strtok(files(f).name,'.') '.dat'];
                    delete(datname);
                end
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nData deleted!\n\n');
        
    case 'copy'
        
        % parameters
        outputstem = p.outputstem;
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % make output directory if it doesn't exist
                outputfullpath = [outputstem subjects{s}];
                if ~exist(outputfullpath,'dir')         
                    mkdir(outputfullpath);
                end
                
                % main process
                copyfile(files(f).name,outputfullpath);
                if strfind(files(f).name,'spm8') % if spm8 file, copy .dat file (in addition to .mat file)     
                    datname = [strtok(files(f).name,'.') '.dat'];
                    copyfile(datname,outputfullpath);
                end
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nData copied!\n\n');
        
    case 'definetrials'
        
        % parameters for SPM function
        fs = p.fs; % assumes maxfilter HASN'T downsampled data
        S.pretrig = p.preEpoch;
        S.posttrig = p.postEpoch;
        S.reviewtrials = 0;
        S.save = 0;
        
        % other parameters
        conditions = p.conditions;
        triggers = p.triggers;
        if isfield(p,'stimuli_list_fname')
            stimuli_list_fname = [pathstem p.stimuli_list_fname];
        end
        
        % setup input structure (define trigger labels)
        for c=1:length(conditions)
            S.trialdef(c).conditionlabel = conditions{c};
            S.trialdef(c).eventtype = 'STI101_up';
            S.trialdef(c).eventvalue = triggers(c);
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);

            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.dataset = files(f).name;

                % main process
                trials = [];
                [trials.trl trials.labels] = spm_eeg_definetrial(S);
                fprintf('\n%d trigger events found...',length(trials.trl));
                
                % correct for trigger-to-sound delay
                if isfield(p,'delay')
                    trials.trl(:,1:2) = trials.trl(:,1:2) + ceil((p.delay/1000)*fs);
                end
                
                % incorporate event information for P6E1 (if stimulus list
                % filename supplied)
                if exist('stimuli_list_fname','var')
                    trials = es_get_events_P6E1(subjects{s},files(f).name,trials,stimuli_list_fname);
                    fprintf('\n%d trigger events remaining after matching triggers to stimuli list...',length(trials.trl));
                end
                
                % save to file
                fname = strtok(files(f).name,'.');
                save(['trlDef_' fname],'trials');
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nTrials defined!\n\n');
        
    case 'definetrials_jp' % uses jp's trigger extraction function + includes ability to block out response triggers
        
        % parameters for jp's trigger function
        cfg.fs = p.fs; % assumes maxfilter HASN'T downsampled data
        cfg.triggers = p.triggers;
        cfg.prestim = -p.preEpoch/1000; % jp's trigger function specifies times with positive numbers only
        cfg.poststim = p.postEpoch/1000;
        cfg.minduration = p.minduration/1000;
        cfg.maxduration = p.maxduration/1000;
        cfg.fromprevious = 0;
        
        % other parameters
        conditions = p.conditions;
        if isfield(p,'stimuli_list_fname')
            stimuli_list_fname = [pathstem p.stimuli_list_fname];
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % main process
                
                % only read select triggers channels (i.e. to block out response triggers)
                B = ft_read_data(files(f).name,'chanindx',[307:310]); % trigger channels STI001 STI002 STI003 STI004 (can represent numbers 0-15. if higher numbers needed, add more channels)
                B(B>0) = 1; % values are 0 or 5, make it binary            
                % for each row, get the values encoded by that channel
                for k=1:size(B,1)
                    B(k,B(k,:)>0) = 2^(k-1);
                end      
                % add up these channels to get the new trigger channel
                sti101_new = sum(B,1);
                
                % get trials
                if strfind(files(f).name,'train')
                    cfg.triggers = p.triggers(4:9);
                    conditions = p.conditions(4:9);
                else
                    cfg.triggers = p.triggers(1:3);
                    conditions = p.conditions(1:3);
                end
                [trials.trl events] = jp_meg_gettrials(sti101_new, cfg);
                for c=1:length(conditions)
                    trials.labels([events.value]==cfg.triggers(c),1)=repmat(conditions(c),sum([events.value]==cfg.triggers(c)),1);
                end
                
                % correct for trigger-to-sound delay
                if isfield(p,'delay')
                    trials.trl(:,1:2) = trials.trl(:,1:2) + ceil((p.delay/1000)*cfg.fs);
                end
                
                % incorporate event information for P6E1 (if stimulus list
                % filename supplied)
                if exist('stimuli_list_fname','var')
                    trials = es_get_events_P6E1(subjects{s},files(f).name,trials,stimuli_list_fname);
                    fprintf('\n%d trigger events remaining after matching triggers to stimuli list...',length(trials.trl));
                end
                
                % save to file
                fname = strtok(files(f).name,'.');
                save(['trlDef_' fname],'trials');
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nTrials defined!\n\n');
     
      case 'artefact_ft'
        
        % parameters for fieldtrip function
        type = p.type;
        z_thresh = p.z;
        feedback = p.feedback;
        if isfield(p,'artefactchans') % look for artefacts in specified channels
            channels = p.artefactchans;
        elseif isfield(p,'montage_fname') % or else look in all EEG and EOG channels
            load([pathstem p.montage_fname]);
            channels = montage.labelorg;
            ind_eeg = find(cellfun(@isempty,strfind(channels,'EEG'))==0);
            ind_eog = find(cellfun(@isempty,strfind(channels,'EOG'))==0);
            channels = channels([ind_eeg ind_eog]);
        else
            error('Please specify channels to look for artefact in');
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            filesTrlDef = dir('*trlDef.mat');

            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % loads trial structure containg trial def
                load(filesTrlDef(f).name);
                
                % exclude bad EEG/EOG channels (if specified)
                channels_clean = {};
                if ~isempty(badeeg{s}) 
                    channels_clean = setdiff(channels,badeeg{s});
                end
                
                % load data
                cfg = [];
                cfg.dataset = files(f).name;
                if ~isempty(channels_clean)
                    cfg.channel = channels_clean;
                else
                    cfg.channel = channels;
                end
                cfg.continuous = 'yes';
                data = ft_preprocessing(cfg);
                
                % setup cfg structure
                cfg = [];
                cfg.trl = trials.trl;
                if cfg.trl(end,2) > length(data.time) % remove last trial if defined to be outside time range of data
                    fprintf('\nNot checking last trial since trial offset defined outside of data range\n');
                    cfg.trl(end,:) = [];
                end

                % cutoff and padding parameters
                if ~isempty(channels_clean)
                    cfg.artfctdef.zvalue.channel = channels_clean;
                else
                    cfg.artfctdef.zvalue.channel = channels;
                end
                if iscell(z_thresh)
                    cfg.artfctdef.zvalue.cutoff = z_thresh{s}(f);
                else
                    cfg.artfctdef.zvalue.cutoff = z_thresh;
                end
                cfg.artfctdef.zvalue.trlpadding = 0;
                cfg.artfctdef.zvalue.artpadding = 0;
                cfg.artfctdef.zvalue.fltpadding = 0.1;
                
                % algorithmic parameters
                if strcmp(type,'EOG')
                    cfg.artfctdef.zvalue.bpfilter   = 'yes';
                    cfg.artfctdef.zvalue.bpfilttype = 'but';
                    cfg.artfctdef.zvalue.bpfreq     = [1 15];
                    cfg.artfctdef.zvalue.bpfiltord  = 4;
                    cfg.artfctdef.zvalue.hilbert    = 'yes';
                elseif strcmp(type,'muscle')
                    cfg.artfctdef.zvalue.bpfilter   = 'yes';
                    cfg.artfctdef.zvalue.bpfilttype = 'but';
                    cfg.artfctdef.zvalue.bpfreq     = [90 120];
                    cfg.artfctdef.zvalue.bpfiltord  = 9;
                    cfg.artfctdef.zvalue.hilbert    = 'yes';
                    cfg.artfctdef.zvalue.boxcar  = 0.2;
                end
                
                % feedback
                cfg.artfctdef.zvalue.feedback = feedback;
                
                if strcmp(type,'EOG')
                    % detect artefacts
                    [cfg artefact_eog] = ft_artifact_zvalue(cfg,data);
                    % reject artefacts
                    cfg=[];
                    cfg.dataset = files(f).name;
                    cfg.trl = trials.trl;
                    cfg.artfctdef.reject = 'complete'; % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
                    cfg.artfctdef.eog.artifact = artefact_eog;
                    trials_clean = ft_rejectartifact(cfg);
                    trials.artefact_eog = setdiff(trials.trl(:,1),trials_clean.trl(:,1)); % stores onset of artefact trial
                    fprintf('\n%f percent of trials rejected',(length(trials.artefact_eog)/length(trials.trl))*100);
                elseif strcmp(type,'muscle')
                    % detect artefacts
                    [cfg artefact_muscle] = ft_artifact_zvalue(cfg,data);
                    % reject artefacts
                    cfg=[];
                    cfg.dataset = files(f).name;
                    cfg.trl = trials.trl;
                    cfg.artfctdef.reject = 'complete'; % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
                    cfg.artfctdef.muscle.artifact = artefact_muscle;
                    trials_clean = ft_rejectartifact(cfg);
                    trials.artefact_muscle = setdiff(trials.trl(:,1),trials_clean.trl(:,1)); % stores onset of artefact trial
                    fprintf('\n%f percent of trials rejected',(length(trials.artefact_muscle)/length(trials.trl))*100);
                end
                
                % save new (clean) trigger file
                save(filesTrlDef(f).name,'trials');
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nData artefact rejected!\n\n');
        
    case 'blink'
        
        % parameters for SPM function
        detect_method = 'Eyes';
        correct_method = 'Berg';
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % copy file
                S = [];
                S.D = spm_eeg_load(files(f).name);
                S.newname = ['clean_' files(f).name];
                Dclean = spm_eeg_copy(S);
                
                % main process 1 (detect spatial confounds)
                S = [];
                S.D = Dclean;
                S.method = detect_method;
                Dclean = spm_eeg_spatial_confounds(S);
                
                % main process 2 (correct spatial confounds)
                S = [];
                S.D = Dclean;
                S.correction = correct_method;
                Dclean = spm_eeg_correct_sensor_data(S);
                Dclean.save;
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nEye blinks removed!\n\n');
        
    case 'convert+epoch' % convert data into SPM format
        
        % parameters for SPM function
        S.continuous = 0;
        S.usetrials = 0;       
        if isfield(p,'channels') % use specified channels
            S.channels = p.channels;
        elseif isfield(p,'montage_fname') % or else use channels specified in montage file
            load([pathstem p.montage_fname]);
            S.channels = montage.labelorg;
        else % or else convert all channels
            S.channels = 'all';
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            filesTrlDef = dir('trlDef*.mat');
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.dataset = files(f).name;
                
                % load trial structure
                load(filesTrlDef(f).name); % loads trial structure
                
                % set trial definition
                S.trl = trials.trl;
                S.conditionlabel = trials.labels;
                
                % main process
                D = spm_eeg_convert(S);
                
                % set bad EEG/EOG channels (if specified)
                if ~isempty(badeeg{s})
                    
                    cids = D.indchannel(badeeg{s});
                    if ~isempty(cids)
                        D = D.badchannels(cids,1);
                        D.save;
                    end
                    
                end
                
                % set bad trials (if EOG artefacts present)
                if isfield(trials,'artefact_eog')
                   
                   [discard ind] = intersect(trials.trl(:,1,1),trials.artefact_eog);
                   D = D.reject(ind,1);
                   D.save;
                    
                end
                
                % set bad trials (if muscle artefacts present)
                if isfield(trials,'artefact_muscle')
                   
                   [discard ind] = intersect(trials.trl(:,1,1),trials.artefact_muscle);
                   D = D.reject(ind,1);
                   D.save;
                    
                end
                
                % add additional event info (if any)
                if isfield(trials,'events_custom')
                   
                   D.events_custom = trials.events_custom; 
                   D.save;
                    
                end
                
                if isfield(p,'montage_fname') % if using reduced 68ch setup,remove sensor position info from sensor location and headshape fields
                    if strcmp(p.montage_fname,'es_montage_all_EEG68ch.mat') || strcmp(p.montage_fname,'es_montage_EEG68ch.mat')
                        if ~isempty(D.sensors('EEG'))
                            eeg_pos = D.sensors('EEG');
                            head_pos = D.fiducials;
                            sens1_ind = find(ismember(eeg_pos.label,'EEG029'));
                            sens2_ind = find(ismember(eeg_pos.label,'EEG039'));
                            sens1_pos = eeg_pos.elecpos(sens1_ind,:);
                            sens2_pos = eeg_pos.elecpos(sens2_ind,:);
                            head_pos.pnt(find(head_pos.pnt(:,1)==sens1_pos(1) & head_pos.pnt(:,2)==sens1_pos(2) & head_pos.pnt(:,3)==sens1_pos(3)),:) = [];
                            head_pos.pnt(find(head_pos.pnt(:,1)==sens2_pos(1) & head_pos.pnt(:,2)==sens2_pos(2) & head_pos.pnt(:,3)==sens2_pos(3)),:) = [];
                            eeg_pos.elecpos([sens1_ind sens1_ind],:) = [];
                            eeg_pos.chanpos([sens1_ind sens2_ind],:) = [];
                            eeg_pos.label([sens1_ind sens2_ind]) = [];
                            D = D.sensors('EEG',eeg_pos);
                            D = D.fiducials(head_pos);
                            D.save;
                        end
                    end
                end
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nData converted!\n\n');
        
    case 'convert' % convert data into SPM format
        
        % parameters for SPM function
        S.continuous = 1;
        S.usetrials = 1;        
        if isfield(p,'channels') % use specified channels
           S.channels = p.channels;
        elseif isfield(p,'montage_fname') % or else use channels specified in montage file
           load([pathstem p.montage_fname]);
           S.channels = montage.labelorg;
        else % or else convert all channels
            S.channels = 'all';
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.dataset = files(f).name;
                
                % main process
                D = spm_eeg_convert(S);
                
                % set bad EEG/EOG channels (if specified)
                if ~isempty(badeeg{s})
                    
                    cids = D.indchannel(badeeg{s});
                    if ~isempty(cids)
                        D = D.badchannels(cids,1);
                        D.save;
                    end
                    
                end
                
                if isfield(p,'montage_fname') % if using reduced 68ch setup,remove sensor position info from sensor location and headshape fields
                    if strcmp(p.montage_fname,'es_montage_all_EEG68ch.mat') || strcmp(p.montage_name,'es_montage_EEG68ch.mat')
                        if ~isempty(D.sensors('EEG'))
                            eeg_pos = D.sensors('EEG');
                            head_pos = D.fiducials;
                            sens1_ind = find(ismember(eeg_pos.label,'EEG029'));
                            sens2_ind = find(ismember(eeg_pos.label,'EEG039'));
                            sens1_pos = eeg_pos.elecpos(sens1_ind,:);
                            sens2_pos = eeg_pos.elecpos(sens2_ind,:);
                            head_pos.pnt(find(head_pos.pnt(:,1)==sens1_pos(1) & head_pos.pnt(:,2)==sens1_pos(2) & head_pos.pnt(:,3)==sens1_pos(3)),:) = [];
                            head_pos.pnt(find(head_pos.pnt(:,1)==sens2_pos(1) & head_pos.pnt(:,2)==sens2_pos(2) & head_pos.pnt(:,3)==sens2_pos(3)),:) = [];
                            eeg_pos.elecpos([sens1_ind sens1_ind],:) = [];
                            eeg_pos.chanpos([sens1_ind sens2_ind],:) = [];
                            eeg_pos.label([sens1_ind sens2_ind]) = [];
                            D = D.sensors('EEG',eeg_pos);
                            D = D.fiducials(head_pos);
                            D.save;
                        end
                    end
                end
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nData converted!\n\n');
        
    case 'epoch'
        
        % parameters for SPM function
        S.bc = 0;
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            filesTrlDef = dir('trlDef*.mat');
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % load trial structure
                load(filesTrlDef(f).name); % loads trial structure
                
                % set trial definition
                S.epochinfo.trl = trials.trl;
                S.epochinfo.conditionlabels = trials.labels;
                
                % main process
                D = spm_eeg_epochs(S);
                
                % set bad trials (if EOG artefacts present)
                if isfield(trials,'artefact_eog')
                   
                   [discard ind] = intersect(trials.trl(:,1,1),trials.artefact_eog);
                   D = D.reject(ind,1);
                   D.save;
                    
                end
                
                % set bad trials (if muscle artefacts present)
                if isfield(trials,'artefact_muscle')
                   
                   [discard ind] = intersect(trials.trl(:,1,1),trials.artefact_muscle);
                   D = D.reject(ind,1);
                   D.save;
                    
                end
                
                % add additional event info (if any)
                if isfield(trials,'events_custom')
                   
                   D.events_custom = trials.events_custom; 
                   D.save;
                    
                end
                
            end % blocks
            
        end % subjects
        
        fprintf('\n\nData epoched!\n\n');
        
    case 'downsample' % filter data
        
        % parameters for SPM function
        S.fsample_new = p.fs_new; 
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_downsample(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nData downsampled!\n\n');
        
    case 'filter' % filter data
        
        % parameters for SPM function
        S.filter.type = 'but';
        S.filter.order = 5;
        S.filter.band = p.filter;
        S.filter.PHz = p.freq;
        S.filter.dir = 'twopass';
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_filter(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nData filtered!\n\n');
              
    case 'merge' % merge data
        
        % parameters for SPM function
        S.recode = 'same';
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            % set input files for merging (note: spm_eeg_merge requires file
            % names as a character array)
            flag = 0;
            mergePrimary = repmat(' ',1,50); % this is to ensure that the first file in list has the sensor locations etc. (because otherwise that information won't be retained in merged file)
            mergeSecondary = repmat(' ',length(files)-1,50);
            count = 0;
            files2merge = [];
            for f=1:length(files)              
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                D = spm_eeg_load(files(f).name);
                files2merge = [files2merge; files(f).name];
%                 if ~isempty(D.fiducials)
%                     flag = 1;
%                     mergePrimary(1,1:length(files(f).name)) = files(f).name;
%                 else
%                     count = count + 1;
%                     mergeSecondary(count,1:length(files(f).name)) = files(f).name;
%                 end

            end
            
%             if flag
%                 files2merge = [mergePrimary; mergeSecondary];
%             else
%                 files2merge = mergeSecondary;
%             end
            
            S.D = files2merge;

            % main process
            spm_eeg_merge(S);
            
        end % subjects
        
        fprintf('\n\nData merged!\n\n');
    
     case 'rereference'
        
        % parameters for SPM function
        S.keepothers = 'no';
        
        if isfield(p,'montage_fname')
            load([pathstem p.montage_fname]); % load montage
        else
            error('Please supply montage filename');
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % find out bad channels for rereferencing
                D = spm_eeg_load(files(f).name);
                bad = D.badchannels;
                
                montage_new = montage; % get custom template montage
                
                montage_new.tra(bad,:) = 0; % leave bad channels untouched
                montage_new.tra(:,bad) = 0;
                for i=1:length(bad)
                    montage_new.tra(bad(i),bad(i)) = 1;
                end
                
                good = setxor(D.meegchannels('EEG'),bad); % rereference (excluding bad channels)
                montage_new.tra(good,good) = -1/length(good);
                for i=1:length(good)
                    montage_new.tra(good(i),good(i)) = (length(good)-1)/length(good);
                end
                
                S.montage = montage_new; % set new montage
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_montage(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nData (EEG) rereferenced!\n\n');    
        
    case 'baseline' % baseline correct data
        
        % parameters for SPM function
        S.time = [p.preBase p.postBase];
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_bc(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nData baseline corrected!\n\n');
        
    case 'artefact' % detect artefacts
        
        % parameters for SPM function
        S.badchanthresh = p.badchanthresh; 
        S.methods.fun = 'threshchan';
        S.methods.settings.threshold = p.thresh;
        S.methods.channels = p.artefactchans;
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_artefact(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nData artefact rejected!\n\n');
        
    case 'average' % average data
        
        % parameters for SPM function
        if p.robust == 1; 
            S.robust.savew = 1; % Robust averaging
            S.robust.bycondition = 0;
            S.robust.ks = 3;
        else
            S.robust = 0; % No robust averaging
        end
        S.circularise = 1; % gives phase locking value (PLV) when averaging phase values of TF data
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % load input file
                S.D = spm_eeg_load(files(f).name);
                
                % main process
                if strcmp(S.D.transformtype,'time')
                    spm_eeg_average(S);
                else
                    spm_eeg_average_TF(S);
                end
                
            end
            
        end % subjects
        
        fprintf('\n\nData averaged!\n\n');
        
    case 'weight' % Compute contrast on averaged data (can perform groups of contrasts such that each group gets written to a different file- if parameters specified as cell arrays)
                      
        % parameters for SPM function
        S.c = p.contrast_weights; % contrast matrix (one row per contrast)
        S.label = p.contrast_labels; % cell array of contrast labels (one row per contrast)
        S.WeightAve = 0;        
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % load input file
                S.D = spm_eeg_load(files(f).name);
                
                % main process
                spm_eeg_weight_epochs(S);
                
            end
            
        end % subjects
            
        
        fprintf('\n\nData contrasted!\n\n');
        
    case 'sort' % sort conditions according to specified order
        
        % parameters for SPM function
        S.condlist = p.conditions;
        S.save = 1;
        
        for s=1:length(subjects) % for multiple subjects
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input files
                S.D = files(f).name;
                
                % main process
                spm_eeg_sort_conditions(S);
                
            end
            
        end
        
        fprintf('\n\nConditions sorted!\n\n');
        
    case 'grand_average' % assumes merged files (i.e. one per subject)
        
        % parameters for SPM function
        S.weighted = 0;
        
        % set input files for averaging
        subjects2average = [];
        for s=1:length(subjects) % for multiple subjects
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            fprintf([ '\n\nProcessing ' files.name '...\n\n' ]);
            
            subjects2average = [subjects2average; [filePath '/' files.name]];
            
        end
        
        % set input files
        S.D = subjects2average;
        
        % setup output filename (have to do this despite what grandmean()
        % documentation says!)
        S.Dout = [pathstem 'g' files.name];
        
        % main process
        spm_eeg_grandmean(S);
        
        fprintf('\n\nData grand averaged!\n\n');
        
    case 'TF' % perform time-frequency analysis
        
        % parameters for SPM function
        S.frequencies = p.freqs;
        S.method = p.method;
        if strcmp('morlet',p.method)
            S.settings.ncycles = p.ncycles;
            S.phase = p.phase;
        elseif strcmp('ft_mtmconvol',p.method)          
            S.settings.timeres = p.timeres;
            S.settings.timestep = p.timestep;
            S.settings.freqres = p.freqres;
        end
        if isfield(p,'tf_chans')
            S.channels = p.tf_chans;
        end

        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_tf(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nData subjected to time-frequency analysis!\n\n');
        
    case 'TF_rescale' % perform baseline correction for time-frequency analysis
        
        % parameters for SPM function
        S.tf.method = 'Diff';
        S.tf.Sbaseline = [p.preBase_tf p.postBase_tf];
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                spm_eeg_tf_rescale(S);
                
            end
            
        end % subjects
        
        fprintf('\n\nTime-frequency analysis baseline corrected!\n\n');
        
    case 'combineplanar' % combine MEGPLANAR sensor pairs using RMS (if no MEGPLANAR sensors present,the resulting file is identical to the input file but filename is prepended with 'p')
        
        correct = p.correctPlanar;
        if correct
            pre = p.preBase; % specify baseline period for baseline correction of RMSed planar gradiometer data
            post = p.postBase;
        end
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % set input file
                S.D = files(f).name;
                
                % main process
                D = spm_eeg_load(S.D);
                D_new = D.clone(['p' fnamedat(D)], size(D));
                
                cind = D.meegchannels('MEGPLANAR');
                if ~isempty(cind)
                    if strcmp(D.transformtype,'time') % for time domain data
                        D(cind,:,:) = es_combineplanar3(D(cind,:,:));
                        D_new(:,:,:) = D(:,:,:);
                        
                        if correct % baseline correction
                            startSample = D_new.indsample(pre/1000);
                            endSample = D_new.indsample(post/1000);
                            D_new(:,:,:) = D_new(:,:,:) - repmat(mean(D_new(:,startSample:endSample,:),2),[1 D.nsamples 1]);
                        end
                    else % for time-frequency domain data
                        D(cind,:,:,:) = es_combineplanar3(D(cind,:,:,:));
                        D_new(:,:,:,:) = D(:,:,:,:);
                        
                        if correct % baseline correction
                            startSample = D_new.indsample(pre/1000);
                            endSample = D_new.indsample(post/1000);
                            D_new(:,:,:,:) = D_new(:,:,:,:) - repmat(mean(D_new(:,:,startSample:endSample,:),2),[1 1 D.nsamples 1]);
                        end
                    end
                end
                
                D_new.save;
                
            end
            
        end % subjects
        
        fprintf('\n\nMEGPLANAR data combined!\n\n');
                   
    case 'image' % assumes merged files (i.e. one per subject)
        
        % parameters for SPM function
        S.n = 32;
        S.interpolate_bad = 1;
        if isfield(p,'tf_freqs_image')
            S.images.fmt = 'frequency'; % average over frequency for TF data
            S.images.freqs = p.tf_freqs_image; % frequencies over which to average for TF data
        elseif isfield(p,'tf_chans_image')
            S.images.fmt = 'channels'; % average over channels for TF data
            S.images.region_no = 1; % always set ROI number to 1
            roi_label = p.tf_roi_image;
            channel_labels = p.tf_chans_image; % channel names for that ROI over which to average (converted to indices below)
        end
        
        % other parameters
        modality = p.mod;
 
        for m=1:length(modality) % for multiple modalities
            
            fprintf([ '\n\nCurrent imaging modality = ' modality{m} '...\n\n' ]);
            
            S.modality = modality{m}; % set imaging modality
            
            for s=1:length(subjects) % for multiple subjects
                
                fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
                
                % change to input directory
                filePath = [pathstem subjects{s}];
                cd(filePath);
                
                % search for input files
                files = dir(prevStep);
                
                fprintf([ '\n\nProcessing ' files.name '...\n\n' ]);
                
                % set input file
                S.D = [pathstem subjects{s} '/' files.name];
                
                % load file (required for subsequent steps)
                D = spm_eeg_load(S.D);
                
                % convert channel names to indices
                if exist('channel_labels','var')
                    if strcmp(channel_labels,'all')
                        S.images.elecs = D.meegchannels(S.modality);
                    else
                        S.images.elecs = D.indchannel(channel_labels);
                        if isempty(S.images.elecs)
                            error('Error: no channels with specified labels found!');
                        end
                    end
                end
                
                % main process
                spm_eeg_convert2images(S);

                % move created folder to modality-specific folder
                if strcmp(D.transformtype,'time') % time-domain data
                        copyfile(strtok(files.name,'.'),S.modality);
                        rmdir(strtok(files.name,'.'),'s');
                else % time-frequency data
                    if strcmp(S.images.fmt,'frequency') % create images by averging over frequency
                        copyfile(sprintf('F%d_%d_%s',S.images.freqs(1),S.images.freqs(2),strtok(files.name,'.')),S.modality);
                        rmdir(sprintf('F%d_%d_%s',S.images.freqs(1),S.images.freqs(2),strtok(files.name,'.')),'s');
                        folders = dir([S.modality '/type*']);
                        for fl=1:length(folders)
                            filePath = [pathstem subjects{s} '/' modality{m} '/' folders(fl).name];
                            cd(filePath);
                            imagefiles = dir('trial*');
                            for i=1:length(imagefiles)
                                if strfind(files.name,'tph')
                                    copyfile(imagefiles(i).name,[sprintf('f%d_%d_phase',S.images.freqs(1),S.images.freqs(2)) '_' imagefiles(i).name]);
                                elseif strfind(files.name,'tf')
                                    copyfile(imagefiles(i).name,[sprintf('f%d_%d_power',S.images.freqs(1),S.images.freqs(2)) '_' imagefiles(i).name]);
                                end
                                delete(imagefiles(i).name);
                            end
                        end
                    elseif strcmp(S.images.fmt,'channels') % create images by averaging over channels
                        copyfile(strtok(files.name,'.'),S.modality);
                        rmdir(strtok(files.name,'.'),'s');
                        folders = dir(sprintf('%s/%dROI_TF_trialtype*',S.modality,S.images.region_no));
                        for fl=1:length(folders)
                            ind = strfind(folders(fl).name,'type');
                            newfoldername = folders(fl).name(ind:end);
                            copyfile([S.modality '/' folders(fl).name],[S.modality '/' newfoldername]);
                            rmdir([S.modality '/' folders(fl).name],'s');
                            filePath = [pathstem subjects{s} '/' modality{m}  '/' newfoldername];
                            cd(filePath);
                            if strfind(files.name,'tph')
                                copyfile('average.img',sprintf('%s_phase.img',roi_label));
                                copyfile('average.hdr',sprintf('%s_phase.hdr',roi_label));
                            elseif strfind(files.name,'tf')
                                copyfile('average.img',sprintf('%s_power.img',roi_label));
                                copyfile('average.hdr',sprintf('%s_power.hdr',roi_label));
                            end
                            delete('average.img');
                            delete('average.hdr');
                            cd('..');
                            cd('..');
                        end                       
                    end
                end
                
            end
            
        end
        
        fprintf('\n\nData converted to image files!\n\n');
        
    case 'smooth'
        
        % parameters for SPM function
        smooth = [p.xSmooth p.ySmooth p.zSmooth];
        
        % other parameters
        modality = p.mod;
        
        for m=1:length(modality)
            
            fprintf([ '\n\nCurrent imaging modality = ' modality{m} '...\n\n' ]);
            
            for s=1:length(subjects) % for multiple subjects
                
                fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
                
                % change to input directory (image folder level)
                filePath = [pathstem subjects{s} '/' modality{m}];
                cd(filePath);
                
                if strcmp(modality{m},'Source')
                    
                    % search for input files
                    files = dir(prevStep);
                    
                    for f=1:length(files)
                        
                        fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                        
                        % set input file
                        inputFile = files(f).name;
                        
                        % main process
                        spm_smooth(inputFile,['sm_' inputFile],smooth);
                        input_images = strvcat(inputFile,['sm_' inputFile]);
                        spm_imcalc_ui(input_images,['sm_' inputFile],'((i1+eps).*i2)./(i1+eps)',{[],[],'float32',0}); % reinsert NaNs for voxels outside space-time volume
                        
                    end
                    
                else
                
                    folders = dir('type*');
                    
                    for fd=1:length(folders)
                        
                        % change to input directory (image file level)
                        filePath = [pathstem subjects{s} '/' modality{m} '/' folders(fd).name];
                        cd(filePath);
                        
                        % search for input files
                        files = dir(prevStep);
                        
                        for f=1:length(files)
                            
                            fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                            
                            % set input file
                            inputFile = files(f).name;
                            
                            % main process
                            spm_smooth(inputFile,['sm_' inputFile],smooth);
                            input_images = strvcat(inputFile,['sm_' inputFile]);
                            spm_imcalc_ui(input_images,['sm_' inputFile],'((i1+eps).*i2)./(i1+eps)',{[],[],'float32',0}); % reinsert NaNs for voxels outside space-time volume
                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
        fprintf('\n\nImage files smoothed!\n\n');

    case 'image_1D' % combine MEGPLANAR sensor pairs using RMS (if no MEGPLANAR sensors present,the resulting file is identical to the input file but filename is prepended with 'p')
        
        % other parameters
        modality = p.mod;
        
        for s=1:length(subjects)
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            % change to input directory
            filePath = [pathstem subjects{s}];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            for f=1:length(files)
                
                fprintf([ '\n\nProcessing ' files(f).name '...\n\n' ]);
                
                % load input file
                D = spm_eeg_load(files(f).name);
                conditions = D.conditions;
                
                for m=1:length(modality)
                    
                    fprintf([ '\n\nCurrent imaging modality = ' modality{m} '...\n\n' ]);
                    
                    for c=1:length(conditions)
                        
                        % main process
                        foldername = [pathstem subjects{s} '/' modality{m} '/1D_type_' conditions{c} '/'];
                        if ~exist(foldername,'dir')
                            mkdir(foldername);
                        end
                        fname = [foldername sprintf('trial%04d.img', c)];
                        
                        chaninds = D.meegchannels(modality{m});
                        coninds = D.indtrial(conditions{c});
                        data = D(chaninds,:,coninds);
                        data = sqrt(nanmean(data.^2,1))';
                        time = D.time*1000;
                        
                        N     = nifti;
                        dat   = file_array(fname, [length(data), 1], 'FLOAT64-LE');
                        N.dat = dat;
                        N.mat = [...
                            diff(time(1:2))   0               0        time(1);...
                            0                 1               0        0;...
                            0                 0               1        0;...
                            0                 0               0        1];
                        N.mat(1,4) = N.mat(1,4) - N.mat(1,1);
                        N.mat_intent = 'Aligned';
                        create(N);
                        
                        N.dat(:, :) = data;
                        
                    end
                    
                end
                
            end
            
        end % subjects
        
        fprintf('\n\nData converted to 1D image files!\n\n');
        
    case 'mask' % make mask for image files so that stats are done only on time window of interest
                % takes as input one unmasked image file (from any subject
                % and condition)
        
        % parameters for SPM function
        S.window = [p.preImageMask p.postImageMask]; % time window outside which to mask
        
        % other parameters
        modality = p.mod;
        
        for m=1:length(modality)
            
            fprintf([ '\n\nCurrent imaging modality = ' modality{m} '...\n\n' ]);
            
            % change to input directory (image folder level)
            filePath = [pathstem subjects{1} '/' modality{m}];
            cd(filePath);
            
            % search for input folders
            folders = dir('type*');
            %folders = dir('1D_type*');
            
            % change to input directory (image file level)
            filePath = [pathstem subjects{1} '/' modality{m} '/' folders(1).name];
            cd(filePath);
            
            % search for input files
            files = dir(prevStep);
            
            fprintf([ '\n\nProcessing ' files.name '...\n\n' ]);
            
            % set input (and output) files
            S.image = files.name;
            %S.outfile = [pathstem sprintf([modality{m} '_mask_%d_%dms.img'],S.window(1),S.window(2))];
            S.outfile = [pathstem sprintf([modality{m} '_1D_mask_%d_%dms.img'],S.window(1),S.window(2))];
            
            % main process
            if ~isempty(strfind(files.name,'tf')) || ~isempty(strfind(files.name,'tph')) || ~isempty(strfind(files.name,'power')) || ~isempty(strfind(files.name,'phase'))
                fprintf('\nMaking time-frequency mask...\n');
                spm_eeg_mask_TF_es(S); % Use custom function if TF data
            else
                fprintf('\nMaking time-domain mask...\n');
                spm_eeg_mask(S); % else use normal SPM function for time-domain data
                %spm_eeg_mask_1D_es(S); % or custom function for 1D data
            end
            
        end
        
        fprintf('\n\nMask for image files made!\n\n');
        
    case 'firstlevel'
        
        % parameters for SPM function
        windows = p.windows;
        
        % other parameters
        modality = p.mod;
             
        for w=1:size(windows,1)
            
            S.window = windows(w,1:2);
            fprintf(sprintf('\n\nWindow %d-%d...\n\n',S.window(1),S.window(2)));
            
            for s=1:length(subjects) % for multiple subjects
                
                fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
                
                for m=1:length(modality)
                    
                    folders = dir([pathstem subjects{s} '/' modality{m} '/type*']);
                    
                    for fl=1:length(folders)
                        
                        fprintf([ '\n\nCurrent condition = ' folders(fl).name '...\n\n' ]);
                        
                        % change to input directory
                        filePath = [pathstem subjects{s} '/' modality{m} '/' folders(fl).name];
                        cd(filePath);
                        
                        % search for input file
                        file = dir(prevStep);
                        
                        fprintf([ '\n\nProcessing ' file.name '...\n\n' ]);
                        
                        % set input file
                        S.images = file.name;
                        S.Pout = filePath;
                        
                        % main process
                        spm_eeg_firstlevel(S);
                        tmpfile = dir('*con*.img');
                        movefile(tmpfile.name,sprintf(['t%d_%d_' file.name],S.window(1),S.window(2)));
                        tmpfile = dir('*con*.hdr');
                        file.name(end-3:end) = '.hdr';
                        movefile(tmpfile.name,sprintf(['t%d_%d_' file.name],S.window(1),S.window(2)));
                        
                    end
                    
                end
                
            end
            
        end
        
        fprintf('\n\nImage files windowed!\n\n');
        
    otherwise
        
        fprintf('\n\nProcess not found. Please try again!\n\n');
        
end