%% Average source images across time-windows

%es_batch_init;
es_batch_init_learning3;

%%

imagetype = {
             'mbfMcspm8_01_raw_ssst_5_t90_130_f1_40';
             'mbfMcspm8_01_raw_ssst_5_t180_240_f1_40';
             'mbfMcspm8_01_raw_ssst_5_t270_420_f1_40';
             'mbfMcspm8_01_raw_ssst_5_t450_700_f1_40';
            };
%outputstem = '/imaging/es03/P3E1/sourceimages2_averagetime/'; 
outputstem = '/imaging/es03/P3E1/sourceimages2_averagetime_learning3/'; 

for s=1:length(subjects)
    
    currentstem = [pathstem subjects{s} '/Source/'];
    
    if ~exist([outputstem subjects{s} '/'])
        mkdir([outputstem subjects{s} '/']);
    end
    
    for con=1:length(conditions)
        
        for im=1:length(imagetype)
            
            file = dir([currentstem imagetype{im} '_' num2str(con) '.nii']);
            Vi = spm_vol([currentstem file.name]);
            img_data = spm_read_vols(Vi);
            img_data_all(:,:,:,im) = img_data;
            
        end
        
        img_data_avg = mean(img_data_all,4);
        Vo = Vi(1);
        Vo.fname = [outputstem subjects{s} '/' conditions{con} '.nii'];
        spm_write_vol(Vo,img_data_avg);
        
    end
    
end

%% Estimate SPM model

% inputstem = '/imaging/es03/P3E1/sourceimages2_averagetime/';
% outputstem = '/imaging/es03/P3E1/stats2_source_averagetime/';
inputstem = '/imaging/es03/P3E1/sourceimages2_averagetime_learning3/';
outputstem = '/imaging/es03/P3E1/stats2_source_averagetime_learning3/';
%mskname = [];
mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % set to [] if not needed

% Contrasts
cnt = 0;
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Distortion';
% contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1 1 1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Congruency';
% contrasts{cnt}.c = kron([1 1 1],orth(diff(eye(3))')');
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Distortion X congruency';
% contrasts{cnt}.c = kron(orth(diff(eye(3))')',orth(diff(eye(3))')');
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match - mismatch';
% contrasts{cnt}.c = kron([1 1 1],[1 -1 0]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Distortion X (match - mismatch)';
% contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1 -1 0]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match - neutral';
% contrasts{cnt}.c = kron([1 1 1],[1 0 -1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Distortion X (match - neutral)';
% contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1 0 -1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Mismatch - neutral';
% contrasts{cnt}.c = kron([1 1 1],[0 1 -1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Distortion X (mismatch - neutral)';
% contrasts{cnt}.c = kron(orth(diff(eye(3))')',[0 1 -1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = '8ch > 2ch';
% contrasts{cnt}.c = kron([-1 0 1],[1 1 1]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = '2ch > 8ch';
% contrasts{cnt}.c = kron([1 0 -1],[1 1 1]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match > mismatch';
% contrasts{cnt}.c = kron([1 1 1],[1 -1 0]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Mismatch > match';
% contrasts{cnt}.c = kron([1 1 1],[-1 1 0]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match > neutral';
% contrasts{cnt}.c = kron([1 1 1],[1 0 -1]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Neutral > match';
% contrasts{cnt}.c = kron([1 1 1],[-1 0 1]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Mismatch > neutral';
% contrasts{cnt}.c = kron([1 1 1],[0 1 -1]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Neutral > mismatch';
% contrasts{cnt}.c = kron([1 1 1],[0 -1 1]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match > (mismatch+neutral)';
% contrasts{cnt}.c = kron([1 1 1],[1 -0.5 -0.5]);
% contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Match < (mismatch+neutral)';
% contrasts{cnt}.c = kron([1 1 1],[-1 0.5 0.5]);
% contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Phase';
contrasts{cnt}.c = kron([-1 1],[1 1 1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = '8ch-2ch';
contrasts{cnt}.c = kron([1 1],[-1 0 1]);
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Phase X 8ch-2ch';
contrasts{cnt}.c = kron([-1 1],[-1 0 1]);
contrasts{cnt}.type = 'F';

outputfullpath = outputstem;
if ~exist(outputfullpath)
    mkdir(outputfullpath);
end

files = {};
for s=1:length(subjects) % specify file locations for batch_spm_anova_vES
    
    for con=1:length(conditions)
        
        files{1}{s}{con} = [inputstem subjects{s} '/' conditions{con} '.nii'];
        
    end
    
end

% set up input structure for batch_spm_anova_vES
S.imgfiles = files;
S.maskimg = mskname;
S.outdir = outputfullpath;
S.contrasts = contrasts;
S.uUFp = 1; % for M/EEG only

batch_spm_anova_version_es(S); % estimate model and compute contrasts


%% Make conjunctions of pairs of t-contrasts (unthresholded)
% This is equivalent to selecting a 'conjunction null' in the GUI
 
names = {'M>MM_AND_M>N.img'; % output name of first conjunction
         'MM>M_AND_N>M.img'; % output name of second conjunction etc.
        };         
contrasts = {'spmT_0013.img' 'spmT_0015.img'; % first pair of contrasts to conjoin
          'spmT_0014.img' 'spmT_0016.img'; % second pair etc.  
         };
         
 for con=1:size(contrasts,1)
         
     Vi1 = spm_vol([outputstem '/' contrasts{con,1}]);
     Vi2 = spm_vol([outputstem '/' contrasts{con,2}]);
     
     img_data1 = spm_read_vols(Vi1);
     img_data2 = spm_read_vols(Vi2);
     img_data1(img_data1<0) = 0; % remove negative values since this is a one-sided t-test
     img_data2(img_data2<0) = 0;
     
     img_data_conj = min(img_data1,img_data2); % conjoin
     
     Vo = Vi1(1);
     Vo.fname = [outputstem '/' names{con}];
     spm_write_vol(Vo,img_data_conj);
         
 end
         
