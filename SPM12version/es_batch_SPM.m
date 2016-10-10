%% Initialise path and subject definitions

es_batch_init; 

%% Configure

modality = {'MEG' 'MEGPLANAR' 'EEG'};
% imagetype = {'t80_120_sm_trial*'
%              't170_230_sm_trial*'
%              't260_420_sm_trial*'
%              't450_700_sm_trial*'
%              };
imagetype = {'sm_trial*'
             };
% modality = {'Source'};
% imagetype = {'cfmcfbMdspm8_01_preTest_raw_ssst_1_t80_120_f1_40*'};
% imagetype = {
%             'cfmcfbMdspm8_01_preTest_raw_ssst_2_t80_120_f1_40*';
%             'cfmcfbMdspm8_01_preTest_raw_ssst_2_t170_230_f1_40*';
%             'cfmcfbMdspm8_01_preTest_raw_ssst_2_t260_420_f1_40*';
%             'cfmcfbMdspm8_01_preTest_raw_ssst_2_t450_700_f1_40*';
%             };

outputstem = '/imaging/es03/P6E1/stats_train_';
%mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % specify in modality loop below if multiple modalities are being estimated. Don't specify if not needed

% Contrasts (don't specify if not needed)
cnt = 0;

%% Test phase contrasts

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre';
contrasts{cnt}.c = kron([-1 1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Sensory detail';
contrasts{cnt}.c = kron([1/2 1/2],orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X Sensory detail';
contrasts{cnt}.c = kron([-1 1],orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X 6ch-1ch';
contrasts{cnt}.c = kron([-1 1],[-1 1 0]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X 6ch-24ch';
contrasts{cnt}.c = kron([-1 1],[0 1 -1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X 24ch-1ch';
contrasts{cnt}.c = kron([-1 1],[-1 0 1]);
contrasts{cnt}.type = 'F';

% cnt = cnt + 1;
% contrasts{cnt}.name = 'Bad Post-Pre';
% contrasts{cnt}.c = kron([1 0],kron([-1 1],[1/3 1/3 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Bad Post-Pre X Sensory detail';
% contrasts{cnt}.c = kron([1 0],kron([-1 1],orth(diff(eye(3))')'));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Bad Post-Pre X 6ch-1ch';
% contrasts{cnt}.c = kron([1 0],kron([-1 1],[-1 1 0]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Bad Post-Pre X 6ch-24ch';
% contrasts{cnt}.c = kron([1 0],kron([-1 1],[0 1 -1]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Bad Post-Pre X 24ch-1ch';
% contrasts{cnt}.c = kron([1 0],kron([-1 1],[-1 0 1]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good Post-Pre';
% contrasts{cnt}.c = kron([0 1],kron([-1 1],[1/3 1/3 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good Post-Pre X Sensory detail';
% contrasts{cnt}.c = kron([0 1],kron([-1 1],orth(diff(eye(3))')'));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good Post-Pre X 6ch-1ch';
% contrasts{cnt}.c = kron([0 1],kron([-1 1],[-1 1 0]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good Post-Pre X 6ch-24ch';
% contrasts{cnt}.c = kron([0 1],kron([-1 1],[0 1 -1]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good Post-Pre X 24ch-1ch';
% contrasts{cnt}.c = kron([0 1],kron([-1 1],[-1 0 1]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good-Bad X Post-Pre';
% contrasts{cnt}.c = kron([-1 1],kron([-1 1],[1/3 1/3 1/3]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good-Bad X Post-Pre X Sensory detail';
% contrasts{cnt}.c = kron([-1 1],kron([-1 1],orth(diff(eye(3))')'));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good-Bad X Post-Pre X 6ch-1ch';
% contrasts{cnt}.c = kron([-1 1],kron([-1 1],[-1 1 0]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good-Bad X Post-Pre X 6ch-24ch';
% contrasts{cnt}.c = kron([-1 1],kron([-1 1],[0 1 -1]));
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Good-Bad X Post-Pre X 24ch-1ch';
% contrasts{cnt}.c = kron([-1 1],kron([-1 1],[-1 0 1]));
% contrasts{cnt}.type = 'F';


%% Any covariates for test phase?

% load('/imaging/es03/P6E1/wordCorrectPercent2.mat'); % loads variable called 'data'
% load('/imaging/es03/P6E1/phonemeSimilarityPercent2.mat'); % loads variable called 'data'
load('/imaging/es03/P6E1/phonemeSimilarityPercentLearning6ch.mat'); % loads variable called 'data'

covariates{1} = zeros(length(subjects)*size(data,2),size(data,2)); % covariate matrix for first group of subjects (indicated by {1} notation). Don't specify if not needed

count = 1;
for c=1:size(data,2)
   covariates{1}(count:count+(length(subjects)-1),c) = detrend(data(:,c),'constant');
   count = count + length(subjects);
end

for c=1:length(contrasts)
   contrasts{c}.c = [contrasts{c}.c zeros(size(contrasts{c}.c,1),size(covariates{1},2))]; 
end

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre covariate';
contrasts{cnt}.c = [ zeros(1,6) kron([-1 1],[1/3 1/3 1/3]) ];
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X Sensory detail covariate';
contrasts{cnt}.c = [ zeros(2,6) kron([-1 1],orth(diff(eye(3))')') ];
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X 6ch-1ch covariate';
contrasts{cnt}.c = [ zeros(1,6) kron([-1 1],[-1 1 0]) ];
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X 6ch-24ch covariate';
contrasts{cnt}.c = [ zeros(1,6) kron([-1 1],[0 1 -1]) ];
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Post-Pre X 24ch-1ch covariate';
contrasts{cnt}.c = [ zeros(1,6) kron([-1 1],[-1 0 1]) ];
contrasts{cnt}.type = 'F';


%% Training phase contrasts

cnt = cnt + 1;
contrasts{cnt}.name = 'Matching-Mismatching';
contrasts{cnt}.c = kron([-1 1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Sensory detail';
contrasts{cnt}.c = kron([1/2 1/2],orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Matching-Mismatching X Sensory detail';
contrasts{cnt}.c = kron([-1 1],orth(diff(eye(3))')');
contrasts{cnt}.type = 'F';

%% Any covariates for training phase?

% load('/imaging/es03/P6E1/wordCorrectPercent2.mat'); % loads variable called 'data'
% load('/imaging/es03/P6E1/phonemeSimilarityPercent2.mat'); % loads variable called 'data'
load('/imaging/es03/P6E1/phonemeSimilarityPercentLearning6ch.mat'); % loads variable called 'data'

covariates{1} = zeros(length(subjects)*size(data,2),size(data,2)); % covariate matrix for first group of subjects (indicated by {1} notation). Don't specify if not needed

count = 1;
for c=1:size(data,2)
   covariates{1}(count:count+(length(subjects)-1),c) = detrend(data(:,c),'constant');
   count = count + length(subjects);
end

for c=1:length(contrasts)
   contrasts{c}.c = [contrasts{c}.c zeros(size(contrasts{c}.c,1),size(covariates{1},2))]; 
end

cnt = cnt + 1;
contrasts{cnt}.name = 'Matching-Mismatching covariate';
contrasts{cnt}.c = [ zeros(1,6) kron([-1 1],[1/3 1/3 1/3]) ];
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Sensory detail covariate';
contrasts{cnt}.c = [ zeros(2,6) kron([1/2 1/2],orth(diff(eye(3))')') ];
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Matching-Mismatching X Sensory detail covariate';
contrasts{cnt}.c = [ zeros(2,6) kron([-1 1],orth(diff(eye(3))')') ];
contrasts{cnt}.type = 'F';

%% Test phase contrasts (source space)

conditions = {'Post-Pre_1' 'Post-Pre_6' 'Post-Pre_24'}; % need to re-specify these because of need to do selected 'difference of differences' contrasts  

cnt = cnt + 1;
contrasts{cnt}.name = 'negative';
contrasts{cnt}.c = [-1/3 -1/3 -1/3];
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '6ch<1ch';
contrasts{cnt}.c = [1 -1 0];
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '6ch<24ch';
contrasts{cnt}.c = [0 -1 1];
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '24ch<1ch';
contrasts{cnt}.c = [1 0 -1];
contrasts{cnt}.type = 'T';

%% Training phase contrasts (source space)

cnt = cnt + 1;
contrasts{cnt}.name = 'Matching>Mismatching';
contrasts{cnt}.c = kron([-1 1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Matching<Mismatching';
contrasts{cnt}.c = kron([1 -1],[1/3 1/3 1/3]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '12>3ch';
contrasts{cnt}.c = kron([1/2 1/2],[-1 0 1]);
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = '12<3ch';
contrasts{cnt}.c = kron([1/2 1/2],[1 0 -1]);
contrasts{cnt}.type = 'T';

%% Estimate models

files = {};
for img=1:length(imagetype)
    
    for m=1:length(modality)
        
        outputfullpath = [outputstem imagetype{img} '/' modality{m}];
        if ~exist(outputfullpath)
            mkdir(outputfullpath);
        end
        
        %if ~exist('group') % if group number hasn't been assigned in es_batch_init, code all subjects as group 1
            group = ones(1,length(subjects));
        %end
        
        for grp=1:max(group)
            
            subjects_group = find(group==grp);
             
            for s=1:length(subjects_group) % specify file locations for batch_spm_anova_vES
                
                for c=1:length(conditions)
                    
                    %if strmatch('Source',modality{m})
                        %file_tmp = dir( [pathstem subjects{subjects_group(s)} '/' modality{m} '/' imagetype{img} num2str(c) '.nii'] );
                    %    file_tmp = dir( [pathstem subjects{subjects_group(s)} '/' modality{m} '/' imagetype{img} '_' conditions{c} '.nii'] );
                    %    files{grp}{s}{c} = [pathstem subjects{subjects_group(s)} '/' modality{m} '/' file_tmp.name];
                    %else
                        file_tmp = [dir( [pathstem subjects{subjects_group(s)} '/' modality{m} '/type_' conditions{c} '/' imagetype{img} '.img'] ); dir( [pathstem subjects{subjects_group(s)} '/' modality{m} '/type_' conditions{c} '/' imagetype{img} '.nii'] )];
                        files{grp}{s}{c} = [pathstem subjects{subjects_group(s)} '/' modality{m} '/type_' conditions{c} '/' file_tmp.name];   
                    %end
                    
                end
                
            end
            
        end
        
        % set up input structure for batch_spm_anova_vES
        S.imgfiles = files;
        S.outdir = outputfullpath;
        S.uUFp = 1; % for M/EEG only
        %S.nsph_flag = 0;
        mskname = [pathstem modality{m} '_mask_0_800ms.img'];
        if exist('mskname'); S.maskimg = mskname; end;
        if exist('contrasts'); S.contrasts = contrasts; end;
        if exist('covariates'); S.user_regs = covariates; end;
        
        % estimate model and compute contrasts
        batch_spm_anova_es(S);
        
    end
    
end 
