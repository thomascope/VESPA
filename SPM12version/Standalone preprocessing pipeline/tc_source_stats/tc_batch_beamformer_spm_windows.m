% function tc_batch_beamformer_spm_windows(~)

%% Average source images across time-windows
%es_batch_init;
%subjects_and_parameters

%%
addpath(pwd);
time_windows = [90 130; 180 240; 270 420; 450 700; 750 900];
%time_windows = [300 450; 525 675; 750 900];
% imagetype = {
%              ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t90_130_f1_40*'];
%              ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t180_240_f1_40*'];
%              ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t270_420_f1_40*'];
%              ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t450_700_f1_40*'];
%              ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t750_900_f1_40*'];
%             };
% imagetype_split = {
%              [uv_pow_cond_Match_4_ceffbMdMrun1_raw_ssst.nii];
%              ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t180_240_f1_40*'];
%              ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t270_420_f1_40*'];
%              ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t450_700_f1_40*'];
%              ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t750_900_f1_40*'];
%             };
% %outputstem = '/imaging/es03/P3E1/sourceimages2_averagetime/'; 
% outputstem = ['/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_beamform/']; 
% 
% for s=1:length(subjects)
%     
%     currentstem = [pathstem subjects{s} '/Source/'];
%     
%     if ~exist([outputstem subjects{s} '/'])
%         mkdir([outputstem subjects{s} '/']);
%     end
%     
%     for con=1:length(conditions)
%         
%         for im=1:length(imagetype)
%             
%             if ~exist([outputstem subjects{s} '/' num2str(time_windows(im,1)) '_' num2str(time_windows(im,2)) '/'])
%                 mkdir([outputstem subjects{s} '/' num2str(time_windows(im,1)) '_' num2str(time_windows(im,2)) '/']);
%             end
%             
%             file = dir([currentstem imagetype{im} '_' num2str(con) '.nii']);
%             if size(file,1) == 0
%                 file = dir([currentstem imagetype_split{im} '_' num2str(con) '.nii']);
%             end
%             Vi = spm_vol([currentstem file.name]);
%             img_data = spm_read_vols(Vi);
%             img_data_all(:,:,:,im) = img_data;
%             
%             %Save each timewindow individually
%             Vo = Vi(1);
%             Vo.fname = [outputstem subjects{s} '/' num2str(time_windows(im,1)) '_' num2str(time_windows(im,2)) '/' conditions{con} '.nii'];
%             spm_write_vol(Vo,img_data);
%             
%         end
%         
%         img_data_avg = mean(img_data_all,4);
%         Vo = Vi(1);
%         Vo.fname = [outputstem subjects{s} '/' conditions{con} '.nii'];
%         spm_write_vol(Vo,img_data_avg);
%         
%     end
%     
% end

%% Estimate SPM model

% inputstem = '/imaging/es03/P3E1/sourceimages2_averagetime/';
% outputstem = '/imaging/es03/P3E1/stats2_source_averagetime/';
%inputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/';
inputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/';
outputstem = [inputstem 'stats/'];
%mskname = [];
mskname = '/imaging/local/spm/spm8/apriori/grey.nii'; % set to [] if not needed

% Contrasts
cnt = 0;

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(All)';
contrasts{cnt}.c =  kron([1 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Controls)';
contrasts{cnt}.c =  kron([1 0],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Match-Mismatch(Patients)';
contrasts{cnt}.c =  kron([0 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Match-Mismatch';
contrasts{cnt}.c = kron([1 -1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Pattop Group X Match-Mismatch';
contrasts{cnt}.c = kron([-1 1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch-Match(All)';
contrasts{cnt}.c =  kron([1 1],kron([1/3 1/3 1/3],[1 -1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch-Match(Controls)';
contrasts{cnt}.c =  kron([1 0],kron([1/3 1/3 1/3],[1 -1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Mismatch-Match(Patients)';
contrasts{cnt}.c =  kron([0 1],kron([1/3 1/3 1/3],[1 -1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Mismatch-Match';
contrasts{cnt}.c = kron([1 -1],kron([1/3 1/3 1/3],[1 -1]));
contrasts{cnt}.type = 'T';

cnt = cnt + 1;
contrasts{cnt}.name = 'Pattop Group X Mismatch-Match';
contrasts{cnt}.c = kron([-1 1],kron([1/3 1/3 1/3],[1 -1]));
contrasts{cnt}.type = 'T';

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
contrasts{cnt}.name = 'Contop Group X Match-Mismatch';
contrasts{cnt}.c = kron([1 -1],kron([1/3 1/3 1/3],[-1 1]));
contrasts{cnt}.type = 'F';

cnt = cnt + 1;
contrasts{cnt}.name = 'Contop Group X Sensory Detail';
contrasts{cnt}.c = kron([1 -1],kron(orth(diff(eye(3))')',[1/2 1/2]));
contrasts{cnt}.type = 'F';

% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Distortion';
% % contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1 1 1]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Congruency';
% % contrasts{cnt}.c = kron([1 1 1],orth(diff(eye(3))')');
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Distortion X congruency';
% % contrasts{cnt}.c = kron(orth(diff(eye(3))')',orth(diff(eye(3))')');
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Match - mismatch';
% % contrasts{cnt}.c = kron([1 1 1],[1 -1 0]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Distortion X (match - mismatch)';
% % contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1 -1 0]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Match - neutral';
% % contrasts{cnt}.c = kron([1 1 1],[1 0 -1]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Distortion X (match - neutral)';
% % contrasts{cnt}.c = kron(orth(diff(eye(3))')',[1 0 -1]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Mismatch - neutral';
% % contrasts{cnt}.c = kron([1 1 1],[0 1 -1]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Distortion X (mismatch - neutral)';
% % contrasts{cnt}.c = kron(orth(diff(eye(3))')',[0 1 -1]);
% % contrasts{cnt}.type = 'F';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = '8ch > 2ch';
% % contrasts{cnt}.c = kron([-1 0 1],[1 1 1]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = '2ch > 8ch';
% % contrasts{cnt}.c = kron([1 0 -1],[1 1 1]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Match > mismatch';
% % contrasts{cnt}.c = kron([1 1 1],[1 -1 0]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Mismatch > match';
% % contrasts{cnt}.c = kron([1 1 1],[-1 1 0]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Match > neutral';
% % contrasts{cnt}.c = kron([1 1 1],[1 0 -1]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Neutral > match';
% % contrasts{cnt}.c = kron([1 1 1],[-1 0 1]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Mismatch > neutral';
% % contrasts{cnt}.c = kron([1 1 1],[0 1 -1]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Neutral > mismatch';
% % contrasts{cnt}.c = kron([1 1 1],[0 -1 1]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Match > (mismatch+neutral)';
% % contrasts{cnt}.c = kron([1 1 1],[1 -0.5 -0.5]);
% % contrasts{cnt}.type = 'T';
% % 
% % cnt = cnt + 1;
% % contrasts{cnt}.name = 'Match < (mismatch+neutral)';
% % contrasts{cnt}.c = kron([1 1 1],[-1 0.5 0.5]);
% % contrasts{cnt}.type = 'T';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Phase';
% contrasts{cnt}.c = kron([-1 1],[1 1 1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = '8ch-2ch';
% contrasts{cnt}.c = kron([1 1],[-1 0 1]);
% contrasts{cnt}.type = 'F';
% 
% cnt = cnt + 1;
% contrasts{cnt}.name = 'Phase X 8ch-2ch';
% contrasts{cnt}.c = kron([-1 1],[-1 0 1]);
% contrasts{cnt}.type = 'F';

% Define groups
controls2average = {};
patients2average = {};
for s=1:size(subjects,2) % for multiple subjects
    
    fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
    
    if group(s) == 1
        fprintf([ '\nIdentified as a control. \n' ]);
        controls2average{end+1} = subjects{s};
        
    elseif group(s) == 2
        fprintf([ '\nIdentified as a patient. \n' ]);
        patients2average{end+1} = subjects{s};
    end
    
end
  
for wind = 1:size(time_windows,1)
    outputfullpath = [outputstem num2str(time_windows(wind,1)) '_' num2str(time_windows(wind,2)) '/'];
    if ~exist(outputfullpath)
        mkdir(outputfullpath);
    end
    
    thisinput = [inputstem num2str(time_windows(wind,1)) '_' num2str(time_windows(wind,2)) '/'];
   
    files = {};
for s=1:length(controls2average) % specify file locations for batch_spm_anova_vES
    
    for con=1:length(conditions)
        
        files{1}{s}{con} = [thisinput controls2average{s} '/uv_pow_cond_' conditions{con} '_ceffbMdMrun1_raw_ssst.nii'];
        if exist(files{1}{s}{con},'file')
        else
            files{1}{s}{con} = [thisinput controls2average{s} '/uv_pow_cond_' conditions{con} '_ceffbMdMrun1_1_raw_ssst.nii'];
        end

    end
    
end
for s=1:length(patients2average) % specify file locations for batch_spm_anova_vES
    
    for con=1:length(conditions)
        
        files{2}{s}{con} = [thisinput patients2average{s} '/uv_pow_cond_' conditions{con} '_ceffbMdMrun1_raw_ssst.nii'];
        if exist(files{2}{s}{con},'file')
        else
            files{2}{s}{con} = [thisinput patients2average{s} '/uv_pow_cond_' conditions{con} '_ceffbMdMrun1_1_raw_ssst.nii'];
        end
    end
    
end
files{1} = files{1}(~cellfun(@isempty,files{1}));
files{2} = files{2}(~cellfun(@isempty,files{2}));

% set up input structure for batch_spm_anova_vES
S.imgfiles = files;
S.maskimg = mskname;
S.outdir = outputfullpath;
S.contrasts = contrasts;
S.uUFp = 1; % for M/EEG only

batch_spm_anova_version_es(S); % estimate model and compute contrasts
    
end

% 
% for im = 1:length(time_windows)
%     outputfullpath = [outputstem num2str(time_windows(im,1)) '_' num2str(time_windows(im,2)) '/'];
%     if ~exist(outputfullpath)
%         mkdir(outputfullpath);
%     end
%     
%     
%     files = {};
%     for s=1:length(controls2average) % specify file locations for batch_spm_anova_vES
%         
%         for con=1:length(conditions)
%             
%             files{1}{s}{con} = [inputstem controls2average{s} '/' num2str(time_windows(im,1)) '_' num2str(time_windows(im,2)) '/' conditions{con} '.nii'];
%             
%         end
%         
%     end
%     for s=1:length(patients2average) % specify file locations for batch_spm_anova_vES
%         
%         for con=1:length(conditions)
%             
%             files{2}{s}{con} = [inputstem patients2average{s} '/' num2str(time_windows(im,1)) '_' num2str(time_windows(im,2)) '/' conditions{con} '.nii'];
%             
%         end
%         
%     end
%     
%     files{1} = files{1}(~cellfun(@isempty,files{1}));
%     files{2} = files{2}(~cellfun(@isempty,files{2}));
%     
%     % set up input structure for batch_spm_anova_vES
%     S.imgfiles = files;
%     S.maskimg = mskname;
%     S.outdir = outputfullpath;
%     S.contrasts = contrasts;
%     S.uUFp = 1; % for M/EEG only
%     
%     batch_spm_anova_version_es(S); % estimate model and compute contrasts
% 
% end

% %% Make conjunctions of pairs of t-contrasts (unthresholded)
% % This is equivalent to selecting a 'conjunction null' in the GUI
%  
% names = {'M>MM_AND_M>N.img'; % output name of first conjunction
%          'MM>M_AND_N>M.img'; % output name of second conjunction etc.
%         };         
% contrasts = {'spmT_0013.img' 'spmT_0015.img'; % first pair of contrasts to conjoin
%           'spmT_0014.img' 'spmT_0016.img'; % second pair etc.  
%          };
%          
%  for con=1:size(contrasts,1)
%          
%      Vi1 = spm_vol([outputstem '/' contrasts{con,1}]);
%      Vi2 = spm_vol([outputstem '/' contrasts{con,2}]);
%      
%      img_data1 = spm_read_vols(Vi1);
%      img_data2 = spm_read_vols(Vi2);
%      img_data1(img_data1<0) = 0; % remove negative values since this is a one-sided t-test
%      img_data2(img_data2<0) = 0;
%      
%      img_data_conj = min(img_data1,img_data2); % conjoin
%      
%      Vo = Vi1(1);
%      Vo.fname = [outputstem '/' names{con}];
%      spm_write_vol(Vo,img_data_conj);
%          
%  end
%          
