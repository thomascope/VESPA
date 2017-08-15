%% Initialise path and subject definitions

%subjects_and_parameters_follow_up; 
pathstem = '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/';
% 
% conditions = {'Mismatch_4' 'Match_4' 'Mismatch_8' 'Match_8' 'Mismatch_16' 'Match_16'};
% 
% contrast_labels = {'Sum all conditions';'Match-MisMatch'; 'Clear minus Unclear'; 'Gradient difference M-MM'};
% contrast_weights = [1, 1, 1, 1, 1, 1; -1, -1, 1, -1, 1, 1; -1, -1, 0, 0, 1, 1; -1, 1, 0, 0, 1, -1];    
%% Configure

filetype = 'PfmcfbMdeMrun1_raw_ssst';
filetypesplit = 'PfmcfbMdeMrun1_1_raw_ssst';

modality = {'MEGMAG' 'MEGCOMB' 'EEG'};
imagetype = {'sm_'};
%p.windows = [-100 900; 90 130; 180 240; 270 420; 450 700; 750 900];
p.windows = [-100 950; 270 420];

outputstem = '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/stats';

%mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % specify in modality loop below if multiple modalities are being estimated. Don't specify if not needed

% Contrasts (don't specify if not needed)
cnt = 0;

% For 1D time contrasts
% for i = 1:3
%     modality{i} = ['time_' modality{i}];
%     imagetype = {};
% end
%% Contrasts (Separate SPMs for patients/controls)

% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match-Mismatch';
% contrasts{cnt}.c = kron([1/3 1/3 1/3],[-1 1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Main effect of sensory detail';
% contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1/2 1/2]);
% contrasts{cnt}.type = 'F';

%% Contrasts (Combined SPM for patients/controls)

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(All)';
contrasts{cnt}.c =  kron([1 1 1 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Controls)';
contrasts{cnt}.c =  kron([1 0 1 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Patients)';
contrasts{cnt}.c =  kron([0 1 0 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Controls baseline)';
contrasts{cnt}.c =  kron([1 0 0 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Patients baseline)';
contrasts{cnt}.c =  kron([0 1 0 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Controls followup)';
contrasts{cnt}.c =  kron([0 0 1 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Patients followup)';
contrasts{cnt}.c =  kron([0 0 0 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Controls difference)';
contrasts{cnt}.c =  kron([-1 0 1 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Patients difference)';
contrasts{cnt}.c =  kron([0 -1 0 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(All)';
contrasts{cnt}.c =  kron([1 1 1 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Controls)';
contrasts{cnt}.c =  kron([1 0 1 0],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Patients)';
contrasts{cnt}.c =  kron([0 1 0 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Controls baseline)';
contrasts{cnt}.c =  kron([1 0 0 0],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Patients baseline)';
contrasts{cnt}.c =  kron([0 1 0 0],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Controls followup)';
contrasts{cnt}.c =  kron([0 0 1 0],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Patients followup)';
contrasts{cnt}.c =  kron([0 0 0 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Controls difference)';
contrasts{cnt}.c =  kron([-1 0 1 0],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Patients followup)';
contrasts{cnt}.c =  kron([0 -1 0 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Group X Match-Mismatch baseline';
contrasts{cnt}.c = kron([1 -1 0 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Group X Sensory Detail baseline';
contrasts{cnt}.c = kron([1 -1 0 0],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Group X Match-Mismatch followup';
contrasts{cnt}.c = kron([0 0 1 -1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Group X Sensory Detail followup';
contrasts{cnt}.c = kron([0 0 1 -1],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Pattop Group X Match-Mismatch baseline';
contrasts{cnt}.c = kron([1 -1 0 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Match-Mismatch baseline';
contrasts{cnt}.c = kron([-1 1 0 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Pattop Group X Match-Mismatch followup';
contrasts{cnt}.c = kron([0 0 1 -1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Match-Mismatch followup';
contrasts{cnt}.c = kron([0 0 -1 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

% Now paired contrasts


first_paired_contrast = cnt+1;
cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(All)';
contrasts{cnt}.c =  kron([1 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Controls)';
contrasts{cnt}.c =  kron([1 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Patients)';
contrasts{cnt}.c =  kron([0 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Main effect of sensory detail(All)';
contrasts{cnt}.c = kron([1 1],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Main effect of sensory detail(Controls)';
contrasts{cnt}.c = kron([1 0],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Main effect of sensory detail(Patients)';
contrasts{cnt}.c = kron([0 1],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(All)';
contrasts{cnt}.c = kron([1 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Controls)';
contrasts{cnt}.c = kron([1 0],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Clear minus unclear(Patients)';
contrasts{cnt}.c = kron([0 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch clear minus unclear(Controls)';
contrasts{cnt}.c = kron([0 1],[-1 0 0 0 1 0]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch clear minus unclear(Patients)';
contrasts{cnt}.c = kron([1 0],[-1 0 0 0 1 0]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match clear minus unclear(Controls)';
contrasts{cnt}.c = kron([0 1],[0 -1 0 0 0 1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match clear minus unclear(Patients)';
contrasts{cnt}.c = kron([1 0],[0 -1 0 0 0 1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Group X Match-Mismatch';
contrasts{cnt}.c = kron([1 -1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Group X Sensory Detail';
contrasts{cnt}.c = kron([1 -1],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Pattop Group X Match-Mismatch';
contrasts{cnt}.c = kron([1 -1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Match-Mismatch';
contrasts{cnt}.c = kron([-1 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Pattop Group X Clear-Unclear';
contrasts{cnt}.c = kron([1 -1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Clear-Unclear';
contrasts{cnt}.c = kron([-1 1],[-0.5 -0.5 0 0 0.5 0.5]);
contrasts{cnt}.type = 'T';

%% Estimate models


%for img=1:length(imagetype)
img = 1;
for wind = 1:length(p.windows)
    for m=1:length(modality)
    %for m = 3
        files = {};
        % set input files for averaging
        controls2average = {};
        patients2average = {};
        controls2rejecteeg = {};
        patients2rejecteeg = {};
        controls_fup_2average = {};
        patients_fup_2average = {};
        controls_fup_2rejecteeg = {};
        patients_fup_2rejecteeg = {};
        controls2average_id = {}; 
        patients2average_id = {};
        controls_fup_2average_id = {};
        patients_fup_2average_id = {};
        for s=1:size(subjects,2) % for multiple subjects
            
            fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
            
            if group(s) == 1
                fprintf([ '\nIdentified as a control baseline. \n' ]);
                controls2average{end+1} = subjects{s};
                controls2rejecteeg{end+1} = rejecteeg{s};
                controls2average_id{end+1} = subjects{s}(end-3:end);               
            elseif group(s) == 2
                fprintf([ '\nIdentified as a patient baseline. \n' ]);
                patients2average{end+1} = subjects{s};
                patients2rejecteeg{end+1} = rejecteeg{s};
                patients2average_id{end+1} = subjects{s}(end-3:end);
            elseif group(s) == 3
                fprintf([ '\nIdentified as a control followup. \n' ]);
                controls_fup_2average{end+1} = subjects{s};
                controls_fup_2rejecteeg{end+1} = rejecteeg{s};
                controls_fup_2average_id{end+1} = subjects{s}(end-7:end-4);               
            elseif group(s) == 4
                fprintf([ '\nIdentified as a patient followup. \n' ]);
                patients_fup_2average{end+1} = subjects{s};
                patients_fup_2rejecteeg{end+1} = rejecteeg{s};
                patients_fup_2average_id{end+1} = subjects{s}(end-7:end-4);
            end
            
        end
        
        [C_con,ia_con,ib_con] = intersect(controls2average_id,controls_fup_2average_id, 'stable');
        [C_pat,ia_pat,ib_pat] = intersect(patients2average_id,patients_fup_2average_id, 'stable');
        
        for groups = 1:4
            if groups == 1
                
                outputfullpath = [outputstem imagetype{img} '/controls_baseline' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' modality{m}];
                if ~exist(outputfullpath)
                    mkdir(outputfullpath);
                end
                
                for s=1:length(controls2average) % specify file locations for batch_spm_anova_vES
                    
                    for c=1:length(conditions)
                        if strcmp(modality{m},'EEG')
                            if controls2rejecteeg{s} == 1
                                %files{1}{s}{c} = [];
                            else
                                files{1}{s}{c} = strjoin([pathstem controls2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                if exist(files{1}{s}{c},'file')
                                else
                                    files{1}{s}{c} = strjoin([pathstem controls2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                end
                            end
                            
                        else
                            files{1}{s}{c} = strjoin([pathstem controls2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            if exist(files{1}{s}{c},'file')
                            else
                                files{1}{s}{c} = strjoin([pathstem controls2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            end
                        end
                    end
                    
                end
                
            elseif groups == 2
                
                outputfullpath = [outputstem imagetype{img} '/patients_baseline' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' modality{m}];
                if ~exist(outputfullpath)
                    mkdir(outputfullpath);
                end
                
                for s=1:length(patients2average) % specify file locations for batch_spm_anova_vES
                    
                    for c=1:length(conditions)
                        
                        if strcmp(modality{m},'EEG')
                            if patients2rejecteeg{s} == 1
                                %files{2}{s}{c} = [];
                            else
                                files{2}{s}{c} = strjoin([pathstem patients2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                if exist(files{2}{s}{c},'file')
                                else
                                    files{2}{s}{c} = strjoin([pathstem patients2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                end
                            end
                        else
                            files{2}{s}{c} = strjoin([pathstem patients2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            if exist(files{2}{s}{c},'file')
                            else
                                files{2}{s}{c} = strjoin([pathstem patients2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            end
                        end
                        
                    end
                    
                end
            elseif groups == 3
                
                outputfullpath = [outputstem imagetype{img} '/controls_followup' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' modality{m}];
                if ~exist(outputfullpath)
                    mkdir(outputfullpath);
                end
                
                for s=1:length(controls_fup_2average) % specify file locations for batch_spm_anova_vES
                    
                    for c=1:length(conditions)
                        if strcmp(modality{m},'EEG')
                            if controls2rejecteeg{s} == 1
                                %files{3}{s}{c} = [];
                            else
                                files{3}{s}{c} = strjoin([pathstem controls_fup_2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                if exist(files{3}{s}{c},'file')
                                else
                                    files{3}{s}{c} = strjoin([pathstem controls_fup_2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                end
                            end
                            
                        else
                            files{3}{s}{c} = strjoin([pathstem controls_fup_2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            if exist(files{3}{s}{c},'file')
                            else
                                files{3}{s}{c} = strjoin([pathstem controls_fup_2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            end
                        end
                    end
                    
                end
                
            elseif groups == 4
                
                outputfullpath = [outputstem imagetype{img} '/patients_baseline' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' modality{m}];
                if ~exist(outputfullpath)
                    mkdir(outputfullpath);
                end
                
                for s=1:length(patients_fup_2average) % specify file locations for batch_spm_anova_vES
                    
                    for c=1:length(conditions)
                        
                        if strcmp(modality{m},'EEG')
                            if patients_fup_2rejecteeg{s} == 1
                                %files{4}{s}{c} = [];
                            else
                                files{4}{s}{c} = strjoin([pathstem patients_fup_2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                if exist(files{4}{s}{c},'file')
                                else
                                    files{4}{s}{c} = strjoin([pathstem patients_fup_2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
                                end
                            end
                        else
                            files{4}{s}{c} = strjoin([pathstem patients_fup_2average{s} '/' modality{m} filetype '/' imagetype 'condition_' conditions{c} '.nii'],'');
                            if exist(files{4}{s}{c},'file')
                            else
                                files{4}{s}{c} = strjoin([pathstem patients_fup_2average{s} '/' modality{m} filetypesplit '/' imagetype 'condition_' conditions{c} '.nii'],'');
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
        files{3} = files{3}(~cellfun(@isempty,files{3}));
        files{4} = files{4}(~cellfun(@isempty,files{4}));
        S.imgfiles = files;
        outputfullpath = [outputstem imagetype{img} '/combined_' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' modality{m}];
        S.outdir = outputfullpath;
        S.uUFp = 1; % for M/EEG only
        %S.nsph_flag = 0;
        if strncmp(modality{m},'time_',5)
            %mskname = [pathstem modality{m}(6:end)
            %'_1D_mask_0_800ms.img']; No need for mask - images created
            %with restricted time window
        else            
            mskname = [pathstem modality{m} sprintf(['_mask_%d_%dms.img'],p.windows(wind,1),p.windows(wind,2))];
            %mskname = [pathstem modality{m} '_mask_-100_800ms.img'];
        end
        if exist('mskname'); S.maskimg = mskname; end;
        if exist('contrasts'); S.contrasts = contrasts(1:[first_paired_contrast-1]); end;
        if exist('covariates'); S.user_regs = covariates; end;
        
        % estimate model and compute contrasts
       % batch_spm_anova_es(S);
        
        
        % Now do paired contrasts
       for s=1:length(C_con)
            for c=1:length(conditions)
                try
                    outfname = [files{1}{ia_con(s)}{c}(1:end-4) '_contrast.nii'];
                    spm_imcalc(strvcat(files{1}{ia_con(s)}{c}, files{3}{ib_con(s)}{c}),outfname,'i1 - i2')
                    contrast_files{1}{s}{c} = outfname;
                end
            end
        end
        for s=1:length(C_pat)
            for c=1:length(conditions)
                try
                    outfname = [files{2}{ia_pat(s)}{c}(1:end-4) '_contrast.nii'];
                    spm_imcalc(strvcat(files{2}{ia_pat(s)}{c}, files{4}{ib_pat(s)}{c}),outfname,'i1 - i2')
                    contrast_files{2}{s}{c} = outfname;
                end
            end
        end
        
        S.imgfiles = contrast_files;
        outputfullpath = [outputstem imagetype{img} '/paired_' num2str(p.windows(wind,1)) '_' num2str(p.windows(wind,2)) '_' modality{m}];
        S.outdir = outputfullpath;
        S.uUFp = 1; % for M/EEG only
        %S.nsph_flag = 0;
        if strncmp(modality{m},'time_',5)
            %mskname = [pathstem modality{m}(6:end)
            %'_1D_mask_0_800ms.img']; No need for mask - images created
            %with restricted time window
        else            
            mskname = [pathstem modality{m} sprintf(['_mask_%d_%dms.img'],p.windows(wind,1),p.windows(wind,2))];
            %mskname = [pathstem modality{m} '_mask_-100_800ms.img'];
        end
        if exist('mskname'); S.maskimg = mskname; end;
        if exist('contrasts'); S.contrasts = contrasts(first_paired_contrast:end); end;
        if exist('covariates'); S.user_regs = covariates; end;
        
        % estimate model and compute contrasts
        batch_spm_anova_es(S);
        
        
    end
end
%end
