%% Initialise path and subject definitions, source analysis parameters

% 1 = MSPgroup, 2 = MSP, 3 = IIDgroup, 4 = IID, 5 =
% LORgroup 35-700ms, 6 = LOR, 7 = MSPgroup 90-130ms, 8 = MSPgroup 450-700ms, 9 =
% LORgroup 90-130ms, 10 = LORgroup 35-700ms MEG, 11 = LORgroup 35-700ms
% MEGPLANAR, 12 = LORgroup 35-700ms EEG

subjects_and_parameters;

invtype = 'LORgroup'; % label for inversion
val = 5; % which field in 'inv' structure to store inversion
group = 1; % whether group inversion should be used (0- single subject, 1- group)
targetfile = 'mbfMcspm8_01_raw_ssst.mat'; % name of target MEEG file
method = 'Imaging';
modality = {}; % MEG, MEGPLANAR, EEG or empty for all modalities
woi = [35 700]; % time-window for inversion
lpf = [0]; % low frequency cutoff for pre-filtering before inversion (Hz)
hpf = [48]; % high frequency cutoff for pre-filtering before inversion (Hz)
Han = 0; % switch for Hanning window when inverting (0 - off, 1 - on)
contype = 'evoked';
%contype = 'trials';
%contype = 'induced';

%% Estimate sources using specified inversion routine (assumes forward model already calculated)

D = {};
parfor s=1:length(subjects)
    
    D{s} = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
    try, D{s}.inv{val} = rmfield(D{s}.inv{val},'comment'); end
    try, D{s}.inv{val} = rmfield(D{s}.inv{val},'inverse' ); end
    try, D{s}.inv{val} = rmfield(D{s}.inv{val},'contrast'); end
    D{s}.val = val;
    %D{s}.inv{val} = D{s}.inv{1}; % copy over forward model details etc. from first inv field
    %D2 = spm_eeg_load(['/imaging/es03/P3E1/preprocess2/' subjects{s} '/' 'mbfMcspm8_01_raw_ssst.mat']); % or copy from a completely different file
    %D{s}.inv{val} = D2.inv{1};
    D2 = spm_eeg_load(['/imaging/es03/P3E1/preprocess2_copy/' subjects{s} '/' 'mbfMcspm8_01_raw_ssst.mat']); % or copy from a completely different file
    D{s}.inv{val} = D2.inv{1};
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
    
    if ~group
        fprintf('\nComputing individual inversions using %s ...\n',D{s}.inv{val}.inverse.type);
        D{s} = spm_eeg_invert(D{s});
        D{s}.save;
    end
    
end

if group
    fprintf('\nComputing group inversion using %s ...\n',D{1}.inv{val}.inverse.type );
    D = spm_eeg_invert(D);
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

%windows = [90 130; 180 240; 270 420; 450 700];
windows = [450 700];
freq = [1 40];

for s=1:length(subjects)

    D = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
    D.val = val;
    D.inv{val}.contrast.woi = windows;
    D.inv{val}.contrast.fboi = freq;
    D.inv{val}.contrast.type = contype;
    
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
             'mbfMcspm8_01_raw_ssst_5_t90_130_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t180_240_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t270_420_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t450_700_f1_40*';
            };

%outputstem = '/imaging/es03/P3E1/sourceimages2/';
outputstem = '/imaging/es03/P3E1/sourceimages2_learning3/';

for im=1:length(imagetype)
        
    for c=1:length(conditions)
        
        conid = num2str(c);
        
        imgs = [];
        for s=1:length(subjects)
            
            file = dir([pathstem subjects{s} '/Source/' imagetype{im} '_' conid '.nii']);
            imgs = [imgs; [pathstem subjects{s} '/Source/' file.name] ];
            
        end
        
        outputdir = [outputstem imagetype{im} '/'];
        if ~exist(outputdir,'dir')
            mkdir(outputdir);
        end
        
        Vi = spm_vol(imgs);
        Vo = Vi(1);
        Vo.fname = [outputdir 'GA_' file.name];
        Vo = spm_imcalc(Vi,Vo,'mean(X)',{1});
        
    end
    
end

%% Compute contrasts of grand-averaged source images

imagetype = {
             'mbfMcspm8_01_raw_ssst_5_t90_130_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t180_240_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t270_420_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t450_700_f1_40*';
            };
        
%inputstem = '/imaging/es03/P3E1/sourceimages2/';
inputstem = '/imaging/es03/P3E1/sourceimages2_learning3/';

for im=1:length(imagetype)
    
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

%% Compute single-subject contrasts of source images

imagetype = {
             'mbfMcspm8_01_raw_ssst_5_t90_130_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t180_240_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t270_420_f1_40*';
             'mbfMcspm8_01_raw_ssst_5_t450_700_f1_40*';
            };
        
%outputstem = '/imaging/es03/P3E1/sourceimages2/';
outputstem = '/imaging/es03/P3E1/sourceimages2_learning3/';

for s=1:length(subjects)
    
    currentstem = [pathstem subjects{s} '/Source/'];
    if ~exist(currentstem)
        mkdir(currentstem);
    end
    
    for im=1:length(imagetype)
        
        for c=1:length(contrast_labels)
            
            files = dir([currentstem imagetype{im} '.nii']);
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
% inversions = [2 3 4 5];
% 
% evidence = [];
% variance_explained = [];
% for s=1:length(subjects)
%     
%     for w=1:length(windows)
%         
%         for i=1:length(inversions)
%     
%             D = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
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
% 
%% Collate model evaluations (% variance explained and log-evidence)

inversions = [1 5];

evidence = [];
variance_explained = [];
for s=1:length(subjects)
    
    D = spm_eeg_load([pathstem subjects{s} '/' targetfile]);
    
    for i=1:length(inversions)
        
        evidence(s,i) = D.inv{inversions(i)}.inverse.F;
        variance_explained(s,i) = D.inv{inversions(i)}.inverse.R2;
        
    end
    
end
