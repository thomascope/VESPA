% List of open inputs
% Head model specification: M/EEG datasets - cfg_files
% Head model specification: Individual structural image - cfg_files
nrun = 21; % enter the number of runs here
%jobfile = {'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/testbeamforming_LCMV_trunkated_restricted_withMNI_job.m'};
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/testbeamforming_originaltimes_LCMV_combined_restricted_withMNI_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, 5*nrun);
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

datadir_90_130 = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/90_130/meg14_0506_vp12/'};
datadir_180_240 = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/180_240/meg14_0506_vp12/'};
                                             
datadir_270_420 = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/270_420/meg14_0506_vp12/'};

datadir_450_700 = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/450_700/meg14_0506_vp12/'};
                                             
datadir_750_900 = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_restricted/750_900/meg14_0506_vp12/'};
                                                                                          

load('/imaging/tc02/vespa/preprocess/controls_mni','controlsmni');
load('/imaging/tc02/vespa/preprocess/patients_mni','patientsmni');
allmni = [controlsmni, patientsmni]';
                                         
if length(meglist)~=nrun || length(mrilist)~=nrun || length(datadir_90_130)~=nrun || length(datadir_180_240)~=nrun
    error('The number of runs specified is not the same as the length of one of the inputs. Please double check this.')
end
for crun = 1:nrun
    inputs{1, crun} = cellstr(meglist{crun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_90_130{crun}); % Data output directory for beamforming
    inputs{7, crun} = [90 130];
    inputs{8, crun} = [90 130];
    mkdir(char(inputs{6, crun}));
end
for crun = nrun+1:2*nrun
    inputs{1, crun} = cellstr(meglist{crun-nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_180_240{crun-nrun}); % Data output directory for beamforming
    inputs{7, crun} = [180 240];
    inputs{8, crun} = [180 240];
    mkdir(char(inputs{6, crun}));
end
for crun = 2*nrun+1:3*nrun
    inputs{1, crun} = cellstr(meglist{crun-2*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-2*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-2*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-2*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-2*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_270_420{crun-2*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [270 420];
    inputs{8, crun} = [270 420];
    mkdir(char(inputs{6, crun}));
end
for crun = 3*nrun+1:4*nrun
    inputs{1, crun} = cellstr(meglist{crun-3*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-3*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-3*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-3*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-3*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_450_700{crun-3*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [450 700];
    inputs{8, crun} = [450 700];
    mkdir(char(inputs{6, crun}));
end
for crun = 4*nrun+1:5*nrun
    inputs{1, crun} = cellstr(meglist{crun-4*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-4*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-4*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-4*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-4*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_750_900{crun-4*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [750 900];
    inputs{8, crun} = [750 900];
    mkdir(char(inputs{6, crun}));
end

% spm('defaults', 'EEG');
% spm_jobman('run', jobs, inputs{:});
beamformingworkedcorrectly = zeros(1,5*nrun);
jobs = repmat(jobfile, 1, 1);
try
spm_rmpath %Because SPM latest doesn't have beamforming toolbox at present
catch
end
parfor crun = 1:5*nrun
    addpath /imaging/local/software/spm_cbu_svn/releases/spm12_fil_r6685;
    addpath('/imaging/local/software/spm_cbu_svn/releases/spm12_fil_r6685/toolbox/DAiSS');
    spm('defaults', 'EEG');
    spm_jobman('initcfg')
    try
        if beamformingworkedcorrectly(crun) == 0 && ~any(size(dir([char(inputs{6,crun}) '/*.nii' ]),1))
            spm_jobman('run', jobs, inputs{:,crun});
            beamformingworkedcorrectly(crun) = 1;
        end
    catch
        beamformingworkedcorrectly(crun) = 0;
    end
end

nrun = 21; % enter the number of runs here
%jobfile = {'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/testbeamforming_LCMV_trunkated_restricted_withMNI_job.m'};
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/testbeamforming_originaltimes_LCMV_combined_broadfreq_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, 5*nrun);

datadir_90_130 = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/90_130/meg14_0506_vp12/'};
datadir_180_240 = {                                              
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/180_240/meg14_0506_vp12/'};
                                             
datadir_270_420 = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/270_420/meg14_0506_vp12/'};

datadir_450_700 = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/450_700/meg14_0506_vp12/'};
                                             
datadir_750_900 = {
                                                '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0072_vc1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0093_vc2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0096_vc3/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0114_vc4/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0320_vc5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0140_vc6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0434_vc7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0218_vc9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0234_vc10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0242_vc11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0253_vc12/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0085_vp1/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0087_vp2/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0121_vp5/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0130_vp6/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0135_vp7/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0150_vp8/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0184_vp9/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0205_vp10/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0222_vp11/'
                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/testbeamforming/originaltimes_final_LCMV_trunkated_broadspectrum/750_900/meg14_0506_vp12/'};

                                             
load('/imaging/tc02/vespa/preprocess/controls_mni','controlsmni');
load('/imaging/tc02/vespa/preprocess/patients_mni','patientsmni');
allmni = [controlsmni, patientsmni]';
                                         
if length(meglist)~=nrun || length(mrilist)~=nrun || length(datadir_90_130)~=nrun || length(datadir_180_240)~=nrun
    error('The number of runs specified is not the same as the length of one of the inputs. Please double check this.')
end
for crun = 1:nrun
    inputs{1, crun} = cellstr(meglist{crun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_90_130{crun}); % Data output directory for beamforming
    inputs{7, crun} = [90 130];
    inputs{8, crun} = [90 130];
    mkdir(char(inputs{6, crun}));
end
for crun = nrun+1:2*nrun
    inputs{1, crun} = cellstr(meglist{crun-nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_180_240{crun-nrun}); % Data output directory for beamforming
    inputs{7, crun} = [180 240];
    inputs{8, crun} = [180 240];
    mkdir(char(inputs{6, crun}));
end
for crun = 2*nrun+1:3*nrun
    inputs{1, crun} = cellstr(meglist{crun-2*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-2*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-2*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-2*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-2*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_270_420{crun-2*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [270 420];
    inputs{8, crun} = [270 420];
    mkdir(char(inputs{6, crun}));
end
for crun = 3*nrun+1:4*nrun
    inputs{1, crun} = cellstr(meglist{crun-3*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-3*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-3*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-3*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-3*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_450_700{crun-3*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [450 700];
    inputs{8, crun} = [450 700];
    mkdir(char(inputs{6, crun}));
end
for crun = 4*nrun+1:5*nrun
    inputs{1, crun} = cellstr(meglist{crun-4*nrun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun-4*nrun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun-4*nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun-4*nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun-4*nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = cellstr(datadir_750_900{crun-4*nrun}); % Data output directory for beamforming
    inputs{7, crun} = [750 900];
    inputs{8, crun} = [750 900];
    mkdir(char(inputs{6, crun}));
end
                                             
beamformingworkedcorrectly = zeros(1,5*nrun);
jobs = repmat(jobfile, 1, 1);                                             
parfor crun = 1:5*nrun
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