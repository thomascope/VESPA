%% Initialise path and subject definitions

es_batch_init_resting_evoked; 

%% Estimate SPM model

%modality = {'MEG' 'MEGPLANAR' 'EEG'};
modality = {'Source'};

%imagetype = {'sm_trial*'};
imagetype = {'mfbcspm8_01_raw_ssst_1_t200_300*' 'mfbcspm8_01_raw_ssst_1_t300_400*'};

outputstem = '/imaging/es03/P3E1/stats4_resting_evoked_';
%mskname = []; % i have put in loop below so that it is modality appropriate
mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % set to [] if not needed

% Contrasts
cnt = 0;

cnt = cnt + 1;
contrasts{cnt}.name = 'Distortion';
contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1/3 1/3 1/3]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Congruency';
contrasts{cnt}.c = kron([1/3 1/3 1/3],orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match - mismatch';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[1 -1 0]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match - neutral';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[1 0 -1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch - neutral';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[0 1 -1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = '8ch > 2ch';
contrasts{cnt}.c = kron([-1 0 1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '2ch > 8ch';
contrasts{cnt}.c = kron([1 0 -1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match > mismatch';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[1 -1 0]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch > match';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[-1 1 0]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match > neutral';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[1 0 -1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Neutral > match';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[-1 0 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch > neutral';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[0 1 -1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Neutral > mismatch';
contrasts{cnt}.c = kron([1/3 1/3 1/3],[0 -1 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '(Match+mismatch) > neutral';
contrasts{cnt}.c = kron([1 1 1],[1/2 1/2 -1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '(Match+mismatch) > neutral';
contrasts{cnt}.c = kron([1 1 1],[-1/2 -1/2 1]);
contrasts{cnt}.type = 'T';

files = {};
for img=1:length(imagetype)
    
    for m=1:length(modality)
        
        %mskname = [pathstem modality{m} '_mask_0_1000ms.img'];
        
        outputfullpath = [outputstem imagetype{img} '/' modality{m}];
        if ~exist(outputfullpath)
            mkdir(outputfullpath);
        end
        
        for s=1:length(subjects) % specify file locations for batch_spm_anova_vES
            
            for c=1:length(conditions)
                
                if strmatch('Source',modality{m})
                    file_tmp = dir( [pathstem subjects{s} '/' modality{m} '/' imagetype{img} num2str(c) '.nii'] );
                    files{1}{s}{c} = [pathstem subjects{s} '/' modality{m} '/' file_tmp.name];
                else
                    file_tmp = dir( [pathstem subjects{s} '/' modality{m} '/type_' conditions{c} '/' imagetype{img} '.img'] );
                    files{1}{s}{c} = [pathstem subjects{s} '/' modality{m} '/type_' conditions{c} '/' file_tmp.name];
                end
                
            end
            
        end
        
        % set up input structure for batch_spm_anova_vES
        S.imgfiles = files;
        S.maskimg = mskname;
        S.outdir = outputfullpath;
        S.contrasts = contrasts;
        S.uUFp = 1; % for M/EEG only
        
        batch_spm_anova_version_es(S); % estimate model and compute contrasts
        
    end
    
end
