%% Initialise path and subject definitions
%clear all

subjects_and_parameters; 

% 
% conditions = {'Mismatch_4' 'Match_4' 'Mismatch_8' 'Match_8' 'Mismatch_16' 'Match_16'};
% 
% contrast_labels = {'Sum all conditions';'Match-MisMatch'; 'Clear minus Unclear'; 'Gradient difference M-MM'};
% contrast_weights = [1, 1, 1, 1, 1, 1; -1, -1, 1, -1, 1, 1; -1, -1, 0, 0, 1, 1; -1, 1, 0, 0, 1, -1];    
%% Configure

filetype = 'fmcfbMdeMrun1_raw_ssst';
filetypesplit = 'fmcfbMdeMrun1_1_raw_ssst';
modality = {'MEG' 'MEGPLANAR' 'EEG'};
imagetype = {'channel_'};
p.windows = [-100 900; 90 130; 180 240; 270 420; 450 700; 750 900];

      %Channel order: MEG overall - control - patient, Planar overall -
      %control - patient, EEG posterior overall, anterior overall -
      %posterior control, anterior control - patient (only anterior)
channels = {'MEG0211' 'MEG0211' 'MEG0131' 'MEG0132' 'MEG0243' 'MEG0132' 'EEG057' 'EEG019' 'EEG046' 'EEG019' 'EEG005'};

pathstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/';
outputstem = '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/stats_best_sensor';

%mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % specify in modality loop below if multiple modalities are being estimated. Don't specify if not needed

% Contrasts (don't specify if not needed)
cnt = 0;
clear contrasts

%% Contrasts (Combined SPM for patients/controls)

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[-1 1]);

%% Collate datafiles

overalldata = struct();
%for img=1:length(imagetype)
img = 1;
for wind = 1:length(p.windows)
    for m=1:length(channels)
    %for m = 3
        files = {};
        % set input files for averaging
        controls2average = {};
        patients2average = {};
        controls2rejecteeg = {};
        patients2rejecteeg= {};
        for s=1:size(subjects,2) % for multiple subjects
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            if group(s) == 1
                fprintf([ '\nIdentified as a control. \n' ]);
                controls2average{end+1} = subjects{s};
                controls2rejecteeg{end+1} = rejecteeg{s};
                               
            elseif group(s) == 2
                fprintf([ '\nIdentified as a patient. \n' ]);
                patients2average{end+1} = subjects{s};
                patients2rejecteeg{end+1} = rejecteeg{s};
            end
            
        end
        
        for groups = 1:2
            if groups == 1
                     
                for s=1:length(controls2average) % specify file locations for batch_spm_anova_vES
                    
                    for c=1:length(conditions)
                        if strncmp(channels{m},'EEG',3)
                            if controls2rejecteeg{s} == 1
                                %files{1}{s}{c} = [];
                            else
                                files{1}{s}{c} = strjoin({[pathstem controls2average{s} '/' filetype '.mat']});
                                if exist(files{1}{s}{c},'file')
                                else
                                    files{1}{s}{c} = strjoin({[pathstem controls2average{s} '/' filetypesplit '.mat']});
                                end
                            end
                            
                        else
                            files{1}{s}{c} = strjoin({[pathstem controls2average{s} '/' filetype '.mat']});
                            if exist(files{1}{s}{c},'file')
                            else
                                files{1}{s}{c} = strjoin({[pathstem controls2average{s} '/' filetypesplit '.mat']});
                            end
                        end
                    end
                    
                end
                
                
%                 % set up input structure for batch_spm_anova_vES
%                 S.imgfiles = files{1}{:}{:};
%                 S.outdir = outputfullpath;
%                 S.uUFp = 1; % for M/EEG only
%                 %S.nsph_flag = 0;
%                 %mskname = [pathstem modality{m} '_mask_0_800ms.img'];
%                 if exist('mskname'); S.maskimg = mskname; end;
%                 if exist('contrasts'); S.contrasts = contrasts; end;
%                 if exist('covariates'); S.user_regs = covariates; end;
%                 
%                 % estimate model and compute contrasts
%                 batch_spm_anova_es(S);
                
                
            elseif groups == 2
                
                for s=1:length(patients2average) % specify file locations for batch_spm_anova_vES
                    
                    for c=1:length(conditions)
                        
                        if strncmp(channels{m},'EEG',3)
                            if patients2rejecteeg{s} == 1
                                %files{2}{s}{c} = [];
                            else
                                files{2}{s}{c} = strjoin({[pathstem patients2average{s} '/' filetype '.mat']});
                                if exist(files{2}{s}{c},'file')
                                else
                                    files{2}{s}{c} = strjoin({[pathstem patients2average{s} '/' filetypesplit '.mat']});
                                end
                            end
                        else
                            files{2}{s}{c} = strjoin({[pathstem patients2average{s} '/' filetype '.mat']});
                            if exist(files{2}{s}{c},'file')
                            else
                                files{2}{s}{c} = strjoin({[pathstem patients2average{s} '/' filetypesplit '.mat']});
                            end
                        end
                        
                    end
                    
                end
                
            end
        end
        
        
        
%         outputfullpath = [outputstem imagetype{img} '/' modality{m}];
%         if ~exist(outputfullpath)
%             mkdir(outputfullpath);
%         end
%         
%         for s=1:length(subjects) % specify file locations for batch_spm_anova_vES
%             
%             for c=1:length(conditions)
%                 
%                 files{1}{s}{c} = strjoin([pathstem subjects{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
%                 
%             end
%             
%         end
            
            
        % set up input structure for batch_spm_anova_vES
        files{1} = files{1}(~cellfun(@isempty,files{1}));
        files{2} = files{2}(~cellfun(@isempty,files{2}));
        S.imgfiles = files;
        outputfullpath = [outputstem '/combined_' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' channels{m}];
        if ~exist(outputfullpath)
            mkdir(outputfullpath);
        end
        S.outdir = outputfullpath;
        S.uUFp = 1; % for M/EEG only
        %S.nsph_flag = 0;
        
        %NB files structure = files{group}{subject number}{condition} - same file per
        %condition here so only need to cycle through group and subject number
        extractedsensor = struct();
        for groups = 1:2
            if groups == 1
                for subjnum = 1:size(files{1},2)
                    clear thischandata D 
                    D = spm_eeg_load(files{groups}{subjnum}{1});
                    extractedsensor.time{groups}{subjnum} = D.time(not(abs(sign(sign(p.windows(wind,1)/1000 - D.time) + sign(p.windows(wind,2)/1000 - D.time)))));
                    extractedsensor.chantype{groups}{subjnum} = D.chantype(D.selectchannels(channels{m}));
                    for conds = 1:length(conditions)
                        thischandata(:,conds) = D(D.selectchannels(channels{m}),:,D.indtrial(conditions{conds}));
                    end
                    extractedsensor.sensordata{groups}{subjnum} = thischandata(not(abs(sign(sign(p.windows(wind,1)/1000 - D.time) + sign(p.windows(wind,2)/1000 - D.time)))),:);
                    for cnt = 1:length(contrasts)
                        extractedsensor.contrastdata{cnt}.name = contrasts{cnt}.name;
                        varthispoint = [];
                        for i = 1:size(extractedsensor.sensordata{groups}{subjnum},1)
                            for j = 1:conds
                                varthispoint(i,j) = extractedsensor.sensordata{groups}{subjnum}(i,j)*contrasts{cnt}.c(j);
                            end
                        end
                        extractedsensor.contrastdata{cnt}.data{groups}{subjnum} = sum(varthispoint');
                        extractedsensor.contrastdata{cnt}.datamean{groups}{subjnum} = mean(extractedsensor.contrastdata{cnt}.data{groups}{subjnum});
                        extractedsensor.contrastdata{cnt}.datastd{groups}{subjnum} = std(extractedsensor.contrastdata{cnt}.data{groups}{subjnum});
                    end
                end
                
            elseif groups == 2
                for subjnum = 1:size(files{2},2)
                    clear thischandata D 
                    D = spm_eeg_load(files{groups}{subjnum}{1});
                    extractedsensor.time{groups}{subjnum} = D.time(not(abs(sign(sign(p.windows(wind,1)/1000 - D.time) + sign(p.windows(wind,2)/1000 - D.time)))));
                    extractedsensor.chantype{groups}{subjnum} = D.chantype(D.selectchannels(channels{m}));
                    for conds = 1:length(conditions)
                        thischandata(:,conds) = D(D.selectchannels(channels{m}),:,D.indtrial(conditions{conds}));
                    end
                    extractedsensor.sensordata{groups}{subjnum} = thischandata(not(abs(sign(sign(p.windows(wind,1)/1000 - D.time) + sign(p.windows(wind,2)/1000 - D.time)))),:);
                    for cnt = 1:length(contrasts)
                        extractedsensor.contrastdata{cnt}.name = contrasts{cnt}.name;
                        varthispoint = [];
                        for i = 1:size(extractedsensor.sensordata{groups}{subjnum},1)
                            for j = 1:conds
                                varthispoint(i,j) = extractedsensor.sensordata{groups}{subjnum}(i,j)*contrasts{cnt}.c(j);
                            end
                        end
                        extractedsensor.contrastdata{cnt}.data{groups}{subjnum} = sum(varthispoint');
                        extractedsensor.contrastdata{cnt}.datamean{groups}{subjnum} = mean(extractedsensor.contrastdata{cnt}.data{groups}{subjnum});
                        extractedsensor.contrastdata{cnt}.datastd{groups}{subjnum} = std(extractedsensor.contrastdata{cnt}.data{groups}{subjnum});
                    end                    
                end
            end                    
        end
        overalldata.channels = channels;
        overalldata.windows = p.windows;
        
        for cnt = 1:length(contrasts)
        [H,P] = ttest2(cell2mat(extractedsensor.contrastdata{cnt}.datamean{1}),cell2mat(extractedsensor.contrastdata{cnt}.datamean{2}),'vartype','unequal');
        extractedsensor.contrastdata{cnt}.H = H;
        extractedsensor.contrastdata{cnt}.p = p;

        overalldata.contrasts{cnt}.name = contrasts{cnt}.name;
        overalldata.significant{m}{wind}{cnt}= H;
        overalldata.pvals{m}{wind}{cnt} = P;
        end
        save([outputfullpath '/extractedsensordata.mat'],'extractedsensor') 
        
        %collate h and p values
    end
end
save([outputstem '/overalldata.mat'],'overalldata') 

%% Display significant contrasts (uncorrected)

for i = 1:length(overalldata.channels)
for wind = 1:length(overalldata.windows)
    if cell2mat(overalldata.significant{i}{wind}) == 1
   disp((['\nSignificant difference at p=' num2str(cell2mat(overalldata.pvals{i}{wind})) ' in sensor ' cell2mat(overalldata.channels(i)) ' in timewindow ' num2str(overalldata.windows(wind,1)) 'ms to ' num2str(overalldata.windows(wind,2)) 'ms']))
        
    end
end
end

