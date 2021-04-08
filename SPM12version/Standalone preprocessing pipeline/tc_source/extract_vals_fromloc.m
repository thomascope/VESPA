% Provide this function a source reconstruction number, an array of contrasts, and
% some 3D coordinates in MNI space. Output an array of values
% individualxcontrastxtimewindowxgroup
% for example:
% [values] = extract_vals_fromloc(6,[0 1/3 0 1/3 0 1/3; 1/3 0 1/3 0 1/3 0],[72,73,47])
% Would output an two cells, each containing a 3D array of values, with each column being an individual, the
% first row being Match, second row MisMatch, the third dimension timewindow. Cell 1 is the control data and cell 2 the patient data.
% NEEDS LOCATION CORRECTION ADDING

function values = extract_vals_fromloc(val,contrast,location);



%% Initialise path and subject definitions, source analysis parameters


addpath('/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline');
subjects_and_parameters;
pathstem = '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/';

if val == 1 || val == 2 || val == 3
    invtype = 'MSPgroup'; % label for inversion
elseif val == 5 || val == 6 || val == 7 || val == 8 || val == 9
    invtype = 'LORgroup'; % label for inversion
end

% val = 2; % which field in 'inv' structure to store inversion
if val < 10
    group_recon = 1; % whether group inversion should be used (0- single subject, 1- group)
elseif val > 10
    group_recon = 0;
end

if val == 1 || val == 2 || val == 5 || val == 8 || val == 9
    modality ={}; % MEG, MEGPLANAR, EEG or empty for all modalities
elseif val == 3 || val == 6
    modality ={'MEGPLANAR'};
elseif val == 3 || val == 7
    modality ={'EEG'};
end

%% Compute group-average of source images

targetfile = 'fmcfbMdeMrun1_raw_ssst';
targetfilesplit = 'fmcfbMdeMrun1_1_raw_ssst';

D = {};
subjectsplit = 3*ones(1,length(subjects));
for s=1:length(subjects)
    if exist([pathstem subjects{s} '/' targetfile '.mat']);
        subjectsplit(s) = 0;
    elseif exist([pathstem subjects{s} '/' targetfilesplit '.mat'])
         subjectsplit(s) = 1;
    else
        error([pathstem subjects{s} '/' targetfile ' does not seem to exist'])
    end
end


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
    ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t90_130_f1_40*'];
    ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t180_240_f1_40*'];
    ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t270_420_f1_40*'];
    ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t450_700_f1_40*'];
    ['fmcfbMdeMrun1_raw_ssst_' num2str(val) '_t750_900_f1_40*'];
    };
imagetype_split = {
    ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t90_130_f1_40*'];
    ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t180_240_f1_40*'];
    ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t270_420_f1_40*'];
    ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t450_700_f1_40*'];
    ['fmcfbMdeMrun1_1_raw_ssst_' num2str(val) '_t750_900_f1_40*'];
    };


values = cell(1,2);
values{1} = zeros(size(contrast,1),length(controls2average),length(imagetype));

for im=1:length(imagetype)
    
    
    imgs = cell(0,length(controls2average));
    for s=1:length(controls2average)
        for row=1:size(contrast,1)
            thisval = zeros(1,size(contrast,2));
            for c = 1:size(contrast,2)
                conid = num2str(c);
                
                
                if controls2averageplit(s) == 0
                    file = dir([pathstem controls2average{s} '/Source/' imagetype{im} '_' conid '.nii']);
                elseif controls2averageplit(s) == 1
                    file = dir([pathstem controls2average{s} '/Source/' imagetype_split{im} '_' conid '.nii']);
                else
                    error('something went wrong with finding the files')
                end
                imgs{s} = [pathstem controls2average{s} '/Source/' file.name];
                Vi = spm_read_vols(spm_vol(imgs{s}));
                thisval(c) = Vi(location(1),location(2),location(3));
            end
            values{1}(row,s,im) = sum(thisval.*contrast(row,:));
        end
    end
    
end

values{2} = zeros(size(contrast,1),length(patients2average),length(imagetype));

for im=1:length(imagetype)
    
    
    imgs = cell(0,length(patients2average));
    for s=1:length(patients2average)
        for row=1:size(contrast,1)
            thisval = zeros(1,size(contrast,2));
            for c = 1:size(contrast,2)
                conid = num2str(c);
                
                
                if patients2averageplit(s) == 0
                    file = dir([pathstem patients2average{s} '/Source/' imagetype{im} '_' conid '.nii']);
                elseif patients2averageplit(s) == 1
                    file = dir([pathstem patients2average{s} '/Source/' imagetype_split{im} '_' conid '.nii']);
                else
                    error('something went wrong with finding the files')
                end
                imgs{s} = [pathstem patients2average{s} '/Source/' file.name];
                Vi = spm_read_vols(spm_vol(imgs{s}));
                thisval(c) = Vi(location(1),location(2),location(3));
            end
            values{2}(row,s,im) = sum(thisval.*contrast(row,:));
        end
    end
    
end
