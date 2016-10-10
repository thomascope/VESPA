%% Initialise path and subject definitions

es_batch_init_learning; 

%% Estimate SPM model

modality = {'MEG' 'MEGPLANAR' 'EEG'};
imagetype = {'sm_trial*'
             };

outputstem = '/imaging/es03/P3E1/stats5_learning_neutral_';
%mskname = [];
%mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % set to [] if not needed

conditions = {'early_2_Neutral';
                   'early_4_Neutral';
                   'early_8_Neutral';
                   'late_2_Neutral';
                   'late_4_Neutral';
                   'late_8_Neutral';
                   };
 
% Contrasts
cnt = 0;

cnt = cnt + 1;
contrasts{cnt}.name = 'Distortion';
contrasts{cnt}.c = kron([1/2 1/2],orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Phase';
contrasts{cnt}.c = kron([-1 1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Phase X Distortion';
contrasts{cnt}.c = kron(orth(diff(eye(2))')',orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

% cnt = cnt + 1;
% contrasts{cnt}.name = 'Distortion';
% contrasts{cnt}.c = kron([1/2 1/2],kron(orth(diff(eye(3))')',[1/3 1/3 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Congruency';
% contrasts{cnt}.c = kron([1/2 1/2],kron([1/3 1/3 1/3],orth(diff(eye(3))')'));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Phase';
% contrasts{cnt}.c = kron([-1 1],kron([1/3 1/3 1/3],[1/3 1/3 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Phase X Distortion';
% contrasts{cnt}.c = kron(orth(diff(eye(2))')',kron(orth(diff(eye(3))')',[1/3 1/3 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Phase (Neutral)';
% contrasts{cnt}.c = kron([-1 1],kron([1/3 1/3 1/3],[0 0 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Phase X Distortion (Neutral)';
% contrasts{cnt}.c = kron(orth(diff(eye(2))')',kron(orth(diff(eye(3))')',[0 0 1/3]));
% contrasts{cnt}.type = 'F';

files = {};
for img=1:length(imagetype)
    
    for m=1:length(modality)
        
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
        mskname = [pathstem modality{m} '_mask_0_800ms.img'];
        S.maskimg = mskname;
        S.outdir = outputfullpath;
        S.contrasts = contrasts;
        S.uUFp = 1; % for M/EEG only
        
        batch_spm_anova_version_es(S); % estimate model and compute contrasts
        
    end
    
end

%% Make conjunctions of pairs of t-contrasts (unthresholded)
% This is equivalent to selecting a 'conjunction null' in the GUI
 
names = {'M>MM_AND_M>N.img'; % output name of first conjunction
         'MM>M_AND_N>M.img'; % output name of second conjunction etc.
        };         
contrasts = {'spmT_0013.img' 'spmT_0015.img'; % first pair of contrasts to conjoin
          'spmT_0014.img' 'spmT_0016.img'; % second pair etc.  
         };
     
for img=1:length(imagetype)

    for m=1:length(modality)
        
        for con=1:size(contrasts,1)
            
            Vi1 = spm_vol([outputstem imagetype{img} '/' modality{m} '/' contrasts{con,1}]);
            Vi2 = spm_vol([outputstem imagetype{img} '/' modality{m} '/' contrasts{con,2}]);
            
            img_data1 = spm_read_vols(Vi1);
            img_data2 = spm_read_vols(Vi2);
            img_data1(img_data1<0) = 0; % remove negative values since this is a one-sided t-test
            img_data2(img_data2<0) = 0;
            
            img_data_conj = min(img_data1,img_data2); % conjoin
            
            Vo = Vi1(1);
            Vo.fname = [outputstem imagetype{img} '/' modality{m} '/' names{con}];
            spm_write_vol(Vo,img_data_conj);
            
        end
             
    end
         
end   
