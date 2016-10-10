%% Initialise path and subject definitions

es_batch_init; 

%% Configure

modality = {'MEG' 'MEGPLANAR' 'EEG'};
imagetype = {'sm_trial*'
             }

outputstem = '/imaging/es03/P6E1/stats_train_';
%mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % specify in modality loop below if multiple modalities are being estimated. Don't specify if not needed

% Contrasts (don't specify if not needed)
cnt = 0;

%% Contrasts

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre';
contrasts{cnt}.c = kron([-1 1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'F';

%% Estimate models

files = {};
for img=1:length(imagetype)
    
    for m=1:length(modality)
        
        outputfullpath = [outputstem imagetype{img} '/' modality{m}];
        if ~exist(outputfullpath)
            mkdir(outputfullpath);
        end
        
        for s=1:length(subjects) % specify file locations for batch_spm_anova_vES
            
            for c=1:length(conditions)
                
                
                file_tmp = [dir( [pathstem subjects{s} '/' modality{m} '/type_' conditions{c} '/' imagetype{img} '.img'] ); dir( [pathstem subjects{s} '/' modality{m} '/type_' conditions{c} '/' imagetype{img} '.nii'] )];
                files{1}{s}{c} = [pathstem subjects{s} '/' modality{m} '/type_' conditions{c} '/' file_tmp.name];
                
            end          
            
            
%             % set up input structure for batch_spm_anova_vES
%             S.imgfiles = files;
%             S.outdir = outputfullpath;
%             S.uUFp = 1; % for M/EEG only
%             %S.nsph_flag = 0;
%             mskname = [pathstem modality{m} '_mask_0_800ms.img'];
%             if exist('mskname'); S.maskimg = mskname; end;
%             if exist('contrasts'); S.contrasts = contrasts; end;
%             if exist('covariates'); S.user_regs = covariates; end;
%             
%             % estimate model and compute contrasts
%             batch_spm_anova_es(S);
            
        end
        
    end
    
end
