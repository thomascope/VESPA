% List of open inputs
% Head model specification: M/EEG datasets - cfg_files
% Head model specification: Individual structural image - cfg_files
nrun = 21; % enter the number of runs here
%jobfile = {'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/testbeamforming_LCMV_trunkated_restricted_withMNI_job.m'};
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/testbeamforming_LCMV_combined_restricted_withMNI_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, 3*nrun);
mrilist = {                                                
                                                 '/imaging/tc02/vespa/preprocess/meg14_0072_vc1/MRI/Recent_Structural/vc1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0093_vc2/MRI/Recent_Structural/vc2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0096_vc3/MRI/Recent_Structural/vc3_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0114_vc4/MRI/Recent_Structural/vc4_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0320_vc5/MRI/Recent_Structural/vc5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0140_vc6/MRI/Recent_Structural/vc6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0434_vc7/MRI/Recent_Structural/vc7_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0218_vc9/MRI/Recent_Structural/vc9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0234_vc10/MRI/Recent_Structural/vc10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0242_vc11/MRI/Recent_Structural/vc11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0253_vc12/MRI/Recent_Structural/vc12_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0085_vp1/MRI/Recent_Structural/vp1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0087_vp2/MRI/Recent_Structural/vp2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0121_vp5/MRI/Recent_Structural/vp5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0130_vp6/MRI/Recent_Structural/vp6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0135_vp7/MRI/template/avg152T1.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0150_vp8/MRI/Recent_Structural/vp8_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0184_vp9/MRI/Recent_Structural/vp9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0205_vp10/MRI/Recent_Structural/vp10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0222_vp11/MRI/Recent_Structural/vp11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0506_vp12/MRI/Recent_Structural/vp12_Structural.nii,1'};
meglist = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0072_vc1/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0093_vc2/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0096_vc3/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0114_vc4/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0320_vc5/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0140_vc6/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0434_vc7/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0218_vc9/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0234_vc10/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0242_vc11/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0253_vc12/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0085_vp1/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0087_vp2/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0121_vp5/ceffbMdMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0130_vp6/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0135_vp7/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0150_vp8/ceffbMdMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0184_vp9/ceffbMdMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0205_vp10/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0222_vp11/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0506_vp12/ceffbMdMrun1_raw_ssst.mat'};

datadir_early = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0506_vp12/'};
datadir_late = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/late/meg14_0506_vp12/'};
                                             
datadir_mid = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_LCMV_trunkated_restricted/mid/meg14_0506_vp12/'};
                                             
                                             

load('/imaging/tc02/vespa/preprocess/controls_mni','controlsmni');
load('/imaging/tc02/vespa/preprocess/patients_mni','patientsmni');
allmni = [controlsmni, patientsmni]';
                                             
if length(meglist)~=nrun || length(mrilist)~=nrun || length(datadir_early)~=nrun || length(datadir_late)~=nrun
    error('The number of runs specified is not the same as the length of one of the inputs. Please double check this.')
end
for crun = 1:nrun
    inputs{1, crun} = cellstr(meglist{crun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_early{crun}); % Data output directory for beamforming
    inputs{7, crun} = [300 450];
    inputs{8, crun} = [300 450];
    mkdir(char(inputs{6, crun}));
end
for crun = nrun+1:2*nrun
    inputs{1, crun} = cellstr(meglist{crun-nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_late{crun-nrun}); % Data output directory for beamforming
    inputs{7, crun} = [650 800];
    inputs{8, crun} = [650 800];
    mkdir(char(inputs{6, crun}));
end
for crun = 2*nrun+1:3*nrun
    inputs{1, crun} = cellstr(meglist{crun-2*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-2*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-2*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-2*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-2*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_mid{crun-2*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [470 600];
    inputs{8, crun} = [470 600];
    mkdir(char(inputs{6, crun}));
end
% spm('defaults', 'EEG');
% spm_jobman('run', jobs, inputs{:});
beamformingworkedcorrectly = zeros(1,3*nrun);
jobs = repmat(jobfile, 1, 1);

try
spm_rmpath %Because SPM latest doesn't have beamforming toolbox at present
catch
end
parfor crun = 1:3*nrun
    addpath /imaging/local/software/spm_cbu_svn/releases/spm12_fil_r6685;
    addpath('/imaging/local/software/spm_cbu_svn/releases/spm12_fil_r6685/toolbox/DAiSS');
    spm('defaults', 'EEG');
    spm_jobman('initcfg')
    try
        if beamformingworkedcorrectly(crun) == 0
            spm_jobman('run', jobs, inputs{:,crun});
            beamformingworkedcorrectly(crun) = 1;
        end
    catch
        beamformingworkedcorrectly(crun) = 0;
    end
end

% List of open inputs
% Head model specification: M/EEG datasets - cfg_files
% Head model specification: Individual structural image - cfg_files
nrun = 21; % enter the number of runs here
%jobfile = {'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/testbeamforming_eLORETA_trunkated_restricted_withMNI_job.m'};
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/eLORETA_restricted_withMNI_trunkated_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, 3*nrun);
mrilist = {                                                
                                                 '/imaging/tc02/vespa/preprocess/meg14_0072_vc1/MRI/Recent_Structural/vc1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0093_vc2/MRI/Recent_Structural/vc2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0096_vc3/MRI/Recent_Structural/vc3_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0114_vc4/MRI/Recent_Structural/vc4_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0320_vc5/MRI/Recent_Structural/vc5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0140_vc6/MRI/Recent_Structural/vc6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0434_vc7/MRI/Recent_Structural/vc7_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0218_vc9/MRI/Recent_Structural/vc9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0234_vc10/MRI/Recent_Structural/vc10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0242_vc11/MRI/Recent_Structural/vc11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0253_vc12/MRI/Recent_Structural/vc12_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0085_vp1/MRI/Recent_Structural/vp1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0087_vp2/MRI/Recent_Structural/vp2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0121_vp5/MRI/Recent_Structural/vp5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0130_vp6/MRI/Recent_Structural/vp6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0135_vp7/MRI/template/avg152T1.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0150_vp8/MRI/Recent_Structural/vp8_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0184_vp9/MRI/Recent_Structural/vp9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0205_vp10/MRI/Recent_Structural/vp10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0222_vp11/MRI/Recent_Structural/vp11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0506_vp12/MRI/Recent_Structural/vp12_Structural.nii,1'};
meglist = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0072_vc1/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0093_vc2/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0096_vc3/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0114_vc4/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0320_vc5/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0140_vc6/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0434_vc7/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0218_vc9/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0234_vc10/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0242_vc11/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0253_vc12/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0085_vp1/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0087_vp2/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0121_vp5/ceffbMdMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0130_vp6/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0135_vp7/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0150_vp8/ceffbMdMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0184_vp9/ceffbMdMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0205_vp10/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0222_vp11/ceffbMdMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0506_vp12/ceffbMdMrun1_raw_ssst.mat'};

datadir_early = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/early/meg14_0506_vp12/'};
datadir_late = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/late/meg14_0506_vp12/'};
                                             
datadir_mid = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/final_eLORETA_trunkated_restricted/mid/meg14_0506_vp12/'};
                                             
                                             

load('/imaging/tc02/vespa/preprocess/controls_mni','controlsmni');
load('/imaging/tc02/vespa/preprocess/patients_mni','patientsmni');
allmni = [controlsmni, patientsmni]';
                                             
if length(meglist)~=nrun || length(mrilist)~=nrun || length(datadir_early)~=nrun || length(datadir_late)~=nrun
    error('The number of runs specified is not the same as the length of one of the inputs. Please double check this.')
end
for crun = 1:nrun
    inputs{1, crun} = cellstr(meglist{crun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_early{crun}); % Data output directory for beamforming
    inputs{7, crun} = [300 450];
    inputs{8, crun} = [300 450];
    mkdir(char(inputs{6, crun}));
end
for crun = nrun+1:2*nrun
    inputs{1, crun} = cellstr(meglist{crun-nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_late{crun-nrun}); % Data output directory for beamforming
    inputs{7, crun} = [650 800];
    inputs{8, crun} = [650 800];
    mkdir(char(inputs{6, crun}));
end
for crun = 2*nrun+1:3*nrun
    inputs{1, crun} = cellstr(meglist{crun-2*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-2*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-2*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-2*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-2*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_mid{crun-2*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [470 600];
    inputs{8, crun} = [470 600];
    mkdir(char(inputs{6, crun}));
end
% spm('defaults', 'EEG');
% spm_jobman('run', jobs, inputs{:});
beamformingworkedcorrectly = zeros(1,3*nrun);
jobs = repmat(jobfile, 1, 1);

try
spm_rmpath %Because SPM latest doesn't have beamforming toolbox at present
catch
end
parfor crun = 1:3*nrun
    addpath /imaging/local/software/spm_cbu_svn/releases/spm12_fil_r6685;
    addpath('/imaging/local/software/spm_cbu_svn/releases/spm12_fil_r6685/toolbox/DAiSS');
    spm('defaults', 'EEG');
    spm_jobman('initcfg')
    try
        if beamformingworkedcorrectly(crun) == 0
            spm_jobman('run', jobs, inputs{:,crun});
            beamformingworkedcorrectly(crun) = 1;
        end
    catch
        beamformingworkedcorrectly(crun) = 0;
    end
end


