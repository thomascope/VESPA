%% Initialise path and subject definitions, source analysis parameters

%Ed's groups
% 1 = MSPgroup, 2 = MSP, 3 = IIDgroup, 4 = IID, 5 =
% LORgroup 35-700ms, 6 = LOR, 7 = MSPgroup 90-130ms, 8 = MSPgroup 450-700ms, 9 =
% LORgroup 90-130ms, 10 = LORgroup 35-700ms MEG, 11 = LORgroup 35-700ms
% MEGPLANAR, 12 = LORgroup 35-700ms EEG

%TEC's groups:
% 1 = MSPgroup with prior locations based on Sohoglu, 2 = MSPgroup without prior for symmetry, 3 = MSPgroup (planar only), 5 = LORgroup 35-950ms (all modalities), 6 = LORgroup
% 35-950ms (MEGPLANAR only), 7 = LORgroup 35-950ms (EEG only), 8 = LORgroup 35-950ms (BOTH MEG only)
% for val = [5,6,7,1,2,3]
for val = [1,5,6,7,2,3]
    
    subjects_and_parameters;
    pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf_thirdICA/';


    if val == 1 || val == 2 || val == 3
        invtype = 'MSPgroup'; % label for inversion
    elseif val == 5 || val == 6 || val == 7 || val == 8
        invtype = 'LORgroup'; % label for inversion
    end

    % val = 2; % which field in 'inv' structure to store inversion
    group_recon = 1; % whether group inversion should be used (0- single subject, 1- group)
    targetfile = 'ceffbMdMrun1_raw_ssst';
    targetfilesplit = 'ceffbMdMrun1_1_raw_ssst';
    method = 'Imaging';
    outputformat = 'image'; %'image' or 'mesh'
    if val == 1 || val == 2 || val == 5
        modality ={}; % MEG, MEGPLANAR, EEG or empty for all modalities
    elseif val == 3 || val == 6
        modality ={'MEGPLANAR'};
    elseif val == 3 || val == 7
        modality ={'EEG'};
    end
    woi = [35 950]; % time-window for inversion
    lpf = [0]; % low frequency cutoff for pre-filtering before inversion (Hz)
    hpf = [48]; % high frequency cutoff for pre-filtering before inversion (Hz)
    Han = 0; % switch for Hanning window when inverting (0 - off, 1 - on)
    %contype = 'evoked';
    %contype = 'trials';
    contype = 'induced';
    
    %% Estimate sources using specified inversion routine (assumes forward model already calculated)
    
    D = {};
    subjectsplit = 3*ones(1,length(subjects));
    for s=1:length(subjects)
        if exist([pathstem subjects{s} '/' targetfile '.mat']);
            D{s} = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
            subjectsplit(s) = 0;
        elseif exist([pathstem subjects{s} '/' targetfilesplit '.mat'])
            D{s} = spm_eeg_load([pathstem subjects{s} '/' targetfilesplit]);
            subjectsplit(s) = 1;
        else
            error([pathstem subjects{s} '/' targetfile ' does not seem to exist'])
        end
        D2 = D{s};
        try, D{s}.inv{val} = rmfield(D{s}.inv{val},'comment'); end
        try, D{s}.inv{val} = rmfield(D{s}.inv{val},'inverse' ); end
        try, D{s}.inv{val} = rmfield(D{s}.inv{val},'contrast'); end
        D{s}.val = val;
        %D{s}.inv{val} = D{s}.inv{1}; % copy over forward model details etc. from first inv field
        %D2 = spm_eeg_load(['/imaging/es03/P3E1/preprocess2/' subjects{s} '/' 'ceffbMdMrun1_raw_ssst.mat']); % or copy from a completely different file
        %D{s}.inv{val} = D2.inv{1};
        %D2 = spm_eeg_load(['/imaging/es03/P3E1/preprocess2_copy/' subjects{s} '/' 'ceffbMdMrun1_raw_ssst.mat']); % or copy from a completely different file
        try
            D{s}.inv{val} = D2.inv{1};
        catch
            pause %Breakpoint here for debug
        end
        D{s}.inv{val}.gainmat = {}; %Re-compute this each time
        D{s}.inv{val}.comment{1} = invtype;
        D{s}.inv{val}.method = method;
        if ~isempty(modality), D{s}.inv{val}.inverse.modality = modality; end
        D{s}.inv{val}.inverse.woi = woi;
        D{s}.inv{val}.inverse.lpf = lpf;
        D{s}.inv{val}.inverse.hpf = hpf;
        D{s}.inv{val}.inverse.Han = Han;
        D{s}.inv{val}.inverse.trials = D{s}.condlist;
        if strfind(invtype,'MSP')
            D{s}.inv{val}.inverse.type   = 'GS';
        elseif strfind(invtype,'IID')
            D{s}.inv{val}.inverse.type   = 'IID';
        elseif strfind(invtype,'LOR')
            D{s}.inv{val}.inverse.type   = 'LOR';
        end
        if val == 1
            %Source priors based on Sohoglu 2012
            D{s}.inv{val}.inverse.xyz = [];
            D{s}.inv{val}.inverse.pQ = {};
            D{s}.inv{val}.inverse.xyz(1,:) = [-54, 18, 20]; %Inferior frontal gyrus, early time window
            D{s}.inv{val}.inverse.xyz(2,:) = [-56,-24, 4]; %STG, late time window
            D{s}.inv{val}.inverse.rad = 32;
        end
        if ~group_recon
            fprintf('\nComputing individual inversions using %s ...\n',D{s}.inv{val}.inverse.type);
            D{s} = spm_eeg_invert(D{s});
            D{s}.save;
        end
        
    end
    
    if group_recon
        fprintf('\nComputing group inversion using %s ...\n',D{1}.inv{val}.inverse.type );
        D = spm_eeg_group_invert_parallelised(D);
        for s = 1:length(subjects)
            D{s}.save;
        end
    end
    
    %% Estimate sources using a group inversion (GUI version)
    
    % files = [];
    % for s=1:length(subjects)
    %
    %     files = [files; [pathstem subjects{s} '/' targetfile] ];
    %
    % end
    %
    % % Perform group inversion
    % spm_eeg_inv_group(files); % GUI will come up to prompt for inversion parameters
    
    %% Compute time-freq contrasts and convert to image files
    
    windows = [350 500; 520 670; 750 900];
    %windows = [450 700];
    freq = [16 31];
    
    parfor s=1:length(subjects)
        if exist([pathstem subjects{s} '/' targetfile '.mat']);
            D = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
            subjectsplit(s) = 0;
        elseif exist([pathstem subjects{s} '/' targetfilesplit '.mat'])
            D = spm_eeg_load([pathstem subjects{s} '/' targetfilesplit]);
            subjectsplit(s) = 1;
        else
            error([pathstem subjects{s} '/' targetfile ' does not seem to exist'])
        end
        D.val = val;
        D.inv{val}.contrast.woi = windows;
        D.inv{val}.contrast.fboi = freq;
        D.inv{val}.contrast.type = contype;
        D.inv{val}.contrast.format = outputformat;
        
        D = spm_eeg_inv_results(D);
        D = spm_eeg_inv_Mesh2Voxels(D);
        D.save;
        
        if ~exist([pathstem subjects{s} '/Source/'])
            mkdir([pathstem subjects{s} '/Source/']);
        end
        imagefiles = dir([pathstem subjects{s} '/*.nii']);
        for i=1:length(imagefiles)
            movefile([pathstem subjects{s} '/' imagefiles(i).name],[pathstem subjects{s} '/Source/']);
        end
        
    end
    
    %% Compute grand-average of source images
    

imagetype = {
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
imagetype_split = {
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
    
    
    %outputstem = '/imaging/es03/P3E1/sourceimages2/';
    outputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_inducedbeta_third_ICA_source/';
    
    parfor im=1:length(imagetype)
        
        for c=1:length(conditions)
            
            conid = num2str(c);
            
            imgs = cell(0,length(subjects));
            for s=1:length(subjects)
                if subjectsplit(s) == 0
                    file = dir([pathstem subjects{s} '/Source/' imagetype{im} '_' conid '.nii']);
                elseif subjectsplit(s) == 1
                    file = dir([pathstem subjects{s} '/Source/' imagetype_split{im} '_' conid '.nii']);
                else
                    error('something went wrong with finding the files')
                end
                imgs{s} = [pathstem subjects{s} '/Source/' file.name];
                
            end
            
            outputdir = [outputstem imagetype{im} '/'];
            if ~exist(outputdir,'dir')
                mkdir(outputdir);
            end
            
            Vi = spm_vol(char(imgs));
            Vo = Vi(1);
            Vo.fname = [outputdir 'GA_' file.name];
            Vo = spm_imcalc(Vi,Vo,'mean(X)',{1});
            
        end
        
    end
    
    %% Compute contrasts of grand-averaged source images
    

imagetype = {
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
imagetype_split = {
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
    
    %inputstem = '/imaging/es03/P3E1/sourceimages2/';
    inputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_inducedbeta_third_ICA_source/';
    
    parfor im=1:length(imagetype)
        
        currentstem = [inputstem '/' imagetype{im} '/'];
        if ~exist(currentstem)
            mkdir(currentstem);
        end
        
        for c=1:length(contrast_labels)
            
            files = dir([currentstem 'GA_' imagetype{im} '.nii']);
            imgs = [];
            for f=1:length(files)
                imgs = [imgs; [currentstem files(f).name]];
            end
            Vi = spm_vol(imgs);
            imgs_data = spm_read_vols(Vi);
            
            tmp = [];
            for i=1:size(imgs,1)
                tmp(:,:,:,i) = imgs_data(:,:,:,i).*contrast_weights(c,i);
            end
            imgs_contrasts_means = sum(tmp,4);
            %imgs_contrasts_means_abs = abs(imgs_contrasts_means);
            
            Vo = Vi(1);
            Vo.fname = [currentstem 'GA_' contrast_labels{c} '.nii'];
            spm_write_vol(Vo,imgs_contrasts_means);
            %Vo.fname = [currentstem contrast_labels{c} '_abs.nii'];
            %spm_write_vol(Vo,imgs_contrasts_means_abs);
            
        end
        
    end
    
     %% Compute group-average of source images
    
     
     % Define groups
     controls2average = {};
     patients2average = {};
     controls2averageplit = [];
     patients2averageplit = [];
     for s=1:size(subjects,2) % for multiple subjects
         
         fprintf([ '\n\nCurrent subject = ' subjects{s} '...\n\n' ]);
         
         if group(s) == 1
             fprintf([ '\nIdentified as a control. \n' ]);
             controls2average{end+1} = subjects{s};
             controls2averageplit(end+1) = subjectsplit(s);
             
         elseif group(s) == 2
             fprintf([ '\nIdentified as a patient. \n' ]);
             patients2average{end+1} = subjects{s};
             patients2averageplit(end+1) = subjectsplit(s);
         end
         
     end
          

imagetype = {
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
imagetype_split = {
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
    
    
    %outputstem = '/imaging/es03/P3E1/sourceimages2/';
    outputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_inducedbeta_third_ICA_source/';
    
    parfor im=1:length(imagetype)
        
        for c=1:length(conditions)
            
            conid = num2str(c);
            
            imgs = cell(0,length(controls2average));
            for s=1:length(controls2average)
                if controls2averageplit(s) == 0
                    file = dir([pathstem controls2average{s} '/Source/' imagetype{im} '_' conid '.nii']);
                elseif controls2averageplit(s) == 1
                    file = dir([pathstem controls2average{s} '/Source/' imagetype_split{im} '_' conid '.nii']);
                else
                    error('something went wrong with finding the files')
                end
                imgs{s} = [pathstem controls2average{s} '/Source/' file.name];
                
            end
            
            outputdir = [outputstem imagetype{im} '/'];
            if ~exist(outputdir,'dir')
                mkdir(outputdir);
            end
            
            Vi = spm_vol(char(imgs));
            Vo = Vi(1);
            Vo.fname = [outputdir 'Controls_' file.name];
            Vo = spm_imcalc(Vi,Vo,'mean(X)',{1});
            
        end
        
    end
    
    parfor im=1:length(imagetype)
        
        for c=1:length(conditions)
            
            conid = num2str(c);
            
            imgs = cell(0,length(patients2average));
            for s=1:length(patients2average)
                if patients2averageplit(s) == 0
                    file = dir([pathstem patients2average{s} '/Source/' imagetype{im} '_' conid '.nii']);
                elseif patients2averageplit(s) == 1
                    file = dir([pathstem patients2average{s} '/Source/' imagetype_split{im} '_' conid '.nii']);
                else
                    error('something went wrong with finding the files')
                end
                imgs{s} = [pathstem patients2average{s} '/Source/' file.name];
                
            end
            
            outputdir = [outputstem imagetype{im} '/'];
            if ~exist(outputdir,'dir')
                mkdir(outputdir);
            end
            
            Vi = spm_vol(char(imgs));
            Vo = Vi(1);
            Vo.fname = [outputdir 'Patients_' file.name];
            Vo = spm_imcalc(Vi,Vo,'mean(X)',{1});
            
        end
        
    end
    
    %% Compute contrasts of group-averaged source images
    

imagetype = {
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
imagetype_split = {
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
    
    %inputstem = '/imaging/es03/P3E1/sourceimages2/';
    inputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_inducedbeta_third_ICA_source/';
    
    parfor im=1:length(imagetype)
        
        currentstem = [inputstem '/' imagetype{im} '/'];
        if ~exist(currentstem)
            mkdir(currentstem);
        end
        
        for c=1:length(contrast_labels)
            
            files = dir([currentstem 'Controls_' imagetype{im} '.nii']);
            imgs = [];
            for f=1:length(files)
                imgs = [imgs; [currentstem files(f).name]];
            end
            Vi = spm_vol(imgs);
            imgs_data = spm_read_vols(Vi);
            
            tmp = [];
            for i=1:size(imgs,1)
                tmp(:,:,:,i) = imgs_data(:,:,:,i).*contrast_weights(c,i);
            end
            imgs_contrasts_means = sum(tmp,4);
            %imgs_contrasts_means_abs = abs(imgs_contrasts_means);
            
            Vo = Vi(1);
            Vo.fname = [currentstem 'Controls_' contrast_labels{c} '.nii'];
            spm_write_vol(Vo,imgs_contrasts_means);
            %Vo.fname = [currentstem contrast_labels{c} '_abs.nii'];
            %spm_write_vol(Vo,imgs_contrasts_means_abs);
            
        end
        
    end
    
    parfor im=1:length(imagetype)
        
        currentstem = [inputstem '/' imagetype{im} '/'];
        if ~exist(currentstem)
            mkdir(currentstem);
        end
        
        for c=1:length(contrast_labels)
            
            files = dir([currentstem 'Patients_' imagetype{im} '.nii']);
            imgs = [];
            for f=1:length(files)
                imgs = [imgs; [currentstem files(f).name]];
            end
            Vi = spm_vol(imgs);
            imgs_data = spm_read_vols(Vi);
            
            tmp = [];
            for i=1:size(imgs,1)
                tmp(:,:,:,i) = imgs_data(:,:,:,i).*contrast_weights(c,i);
            end
            imgs_contrasts_means = sum(tmp,4);
            %imgs_contrasts_means_abs = abs(imgs_contrasts_means);
            
            Vo = Vi(1);
            Vo.fname = [currentstem 'Patients_' contrast_labels{c} '.nii'];
            spm_write_vol(Vo,imgs_contrasts_means);
            %Vo.fname = [currentstem contrast_labels{c} '_abs.nii'];
            %spm_write_vol(Vo,imgs_contrasts_means_abs);
            
        end
        
    end
    
    %% Compute single-subject contrasts of source images
    

imagetype = {
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
imagetype_split = {
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t350_500_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t520_670_f16_31*'];
             ['ceffbMdMrun1_1_raw_ssst_' num2str(val) '_t750_900_f16_31*'];
            };
    
    %outputstem = '/imaging/es03/P3E1/sourceimages2/';
    outputstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_inducedbeta_third_ICA_source/';
    
    parfor s=1:length(subjects)
        s
        currentstem = [pathstem subjects{s} '/Source/'];
        if ~exist(currentstem)
            mkdir(currentstem);
        end
        
        for im=1:length(imagetype)
            
            for c=1:length(contrast_labels)
                
                files = dir([currentstem imagetype{im} '.nii']);
                if size(files,1) == 0
                    files = dir([currentstem imagetype_split{im} '.nii']);
                end
                imgs = [];
                for f=1:length(files)
                    imgs = [imgs; [currentstem files(f).name]];
                end
                Vi = spm_vol(imgs);
                imgs_data = spm_read_vols(Vi);
                
                tmp = [];
                for i=1:size(imgs,1)
                    tmp(:,:,:,i) = imgs_data(:,:,:,i).*contrast_weights(c,i);
                end
                imgs_contrasts_means = sum(tmp,4);
                %imgs_contrasts_means_abs = abs(imgs_contrasts_means);
                
                if ~exist([outputstem imagetype{im} '/' subjects{s} '/'])
                    mkdir([outputstem imagetype{im} '/' subjects{s} '/']);
                end
                
                imgs_contrasts_means = imgs_contrasts_means + 0 ./ (imgs_contrasts_means~=0); % NaN zeros
                %imgs_contrasts_means_abs = imgs_contrasts_means_abs + 0 ./ (imgs_contrasts_means_abs~=0); % NaN zeros
                
                Vo = Vi(1);
                Vo.fname = [outputstem imagetype{im} '/' subjects{s} '/' contrast_labels{c} '.nii'];
                spm_write_vol(Vo,imgs_contrasts_means);
                %Vo.fname = [currentstem contrast_labels{c} '_abs.nii'];
                %spm_write_vol(Vo,imgs_contrasts_means_abs);
                
            end
            
        end
        
    end
    
    %% Inspect inversions
    
    % windows = [90 130; 180 240; 270 420; 450 700];
    % inversions = [1 5];
    %
    % evidence = [];
    % variance_explained = [];
    % for s=1:length(subjects)
    %
    %     for w=1:length(windows)
    %
    %         for i=1:length(inversions)
    %
%         if exist([pathstem subjects{s} '/' targetfile '.mat']);
%             D = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
%             subjectsplit(s) = 0;
%         elseif exist([pathstem subjects{s} '/' targetfilesplit '.mat'])
%             D = spm_eeg_load([pathstem subjects{s} '/' targetfilesplit]);
%             subjectsplit(s) = 1;
%         else
%             error([pathstem subjects{s} '/' targetfile ' does not seem to exist'])
%         end
    %
    %             D.val = inversions(i);
    %             spm_eeg_invert_display(D,windows(w,1)+(windows(w,2)-windows(w,1)));
    %             pause;
    %
    %         end
    %
    %     end
    %
    % end
end   
    % Collate model evaluations (% variance explained and log-evidence)
    
    inversions = [1 2 3 5 6 7];
    
    evidence = [];
    variance_explained = [];
    for s=1:length(subjects)
        s
        if exist([pathstem subjects{s} '/' targetfile '.mat']);
            D = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
            subjectsplit(s) = 0;
        elseif exist([pathstem subjects{s} '/' targetfilesplit '.mat'])
            D = spm_eeg_load([pathstem subjects{s} '/' targetfilesplit]);
            subjectsplit(s) = 1;
        else
            error([pathstem subjects{s} '/' targetfile ' does not seem to exist'])
        end
    
        for i=1:length(inversions)
    
            evidence(s,i) = D.inv{inversions(i)}.inverse.F;
            variance_explained(s,i) = D.inv{inversions(i)}.inverse.R2;
    
        end
    
    end
