%% Initialise path and subject definitions

es_batch_init_TF; 

%% Estimate SPM model

modality = {'EEG'};
imagetype = {'5ROI_phase*'};
%modality = {'Source'};
%imagetype = {'F5_8_umtph_bcspm8_01_raw_ssst_2_t0_200_f'};
%imagetype = {'sm_bMcspm8_01_raw_ssst_10_t200_450_f18' 'sm_bMcspm8_01_raw_ssst_2_t400_1000_f10' 'sm_bMcspm8_01_raw_ssst_3_t200_450_f18'};

outputstem = '/imaging/es03/P3E1/stats4_TF_MM-N_';
%mskname = []; % i have put in loop below so that it is modality appropriate
%mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % set to [] if not needed

conditions = {'Mismatch-neutral'};

% Contrasts
cnt = 0;

cnt = cnt + 1;
contrasts{cnt}.name = '8ch > 2ch';
contrasts{cnt}.c = kron([-1 0 1],[1 1 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '2ch > 8ch';
contrasts{cnt}.c = kron([1 0 -1],[1 1 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match > mismatch';
contrasts{cnt}.c = kron([1 1 1],[1 -1 0]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch > match';
contrasts{cnt}.c = kron([1 1 1],[-1 1 0]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match > neutral';
contrasts{cnt}.c = kron([1 1 1],[1 0 -1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Neutral > match';
contrasts{cnt}.c = kron([1 1 1],[-1 0 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch > neutral';
contrasts{cnt}.c = kron([1 1 1],[0 1 -1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Neutral > mismatch';
contrasts{cnt}.c = kron([1 1 1],[0 -1 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Distortion X Congruency';
contrasts{cnt}.c = kron(orth(diff(eye(3))')',orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

files = {};
for img=1:length(imagetype)
    
    for m=1:length(modality)
        
        mskname = [pathstem modality{m} '_mask_0_1000ms.img'];
        
        outputfullpath = [outputstem imagetype{img} '/' modality{m}];
        if ~exist(outputfullpath)
            mkdir(outputfullpath);
        end
        
        for s=1:length(subjects) % specify file locations for batch_spm_anova_vES
            
            for c=1:length(conditions)
                
                if strcmp('Source',modality{m})
                    file_tmp = dir( [pathstem subjects{s} '/' modality{m} '/' imagetype{img} '_' num2str(c) '.nii'] );
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
        %S.contrasts = contrasts;
        S.uUFp = 1; % for M/EEG only
        
        batch_spm_anova_version_es(S); % estimate model and compute contrasts
        
    end
    
end

%% Make conjunctions of pairs of t-contrasts (unthresholded)
% This is equivalent to selecting a 'conjunction null' in the GUI
 
names = {'M-MM_AND_M-N.img'; % output name of first conjunction
         'M-N_AND_MM-N.img'; % output name of second conjunction etc.
         'MM-M_AND_N-M.img';
        };         
contrasts = {'spmT_0004.img' 'spmT_0006.img'; % first pair of contrasts to conjoin
          'spmT_0006.img' 'spmT_0008.img'; % second pair etc.
          'spmT_0005.img' 'spmT_0007.img';
         };
twotailed = 1; % keep both sides of T statistic?
     
for img=1:length(imagetype)

    for m=1:length(modality)
        
        for con=1:size(contrasts,1)
            
            Vi1 = spm_vol([outputstem imagetype{img} '/' modality{m} '/' contrasts{con,1}]);
            Vi2 = spm_vol([outputstem imagetype{img} '/' modality{m} '/' contrasts{con,2}]);
            
            img_data1 = spm_read_vols(Vi1);
            img_data2 = spm_read_vols(Vi2);
            if ~twotailed
                img_data1(img_data1<0) = 0;
                img_data2(img_data2<0) = 0;
            end
            
            % conjoin
            if ~twotailed
                img_data_conj = min(img_data1,img_data2);
            else
                ind_pos = img_data1>=0;
                ind_neg = img_data1<0;
                img_data_conj_pos = min(img_data1(ind_pos),img_data2(ind_pos));
                img_data_conj_neg = max(img_data1(ind_neg),img_data2(ind_neg));
                img_data_conj = img_data1;
                img_data_conj(ind_pos) = img_data_conj_pos;
                img_data_conj(ind_neg) = img_data_conj_neg;
            end
            
            Vo = Vi1(1);
            Vo.fname = [outputstem imagetype{img} '/' modality{m} '/' names{con}];
            spm_write_vol(Vo,img_data_conj);
            
        end
             
    end
         
end   
