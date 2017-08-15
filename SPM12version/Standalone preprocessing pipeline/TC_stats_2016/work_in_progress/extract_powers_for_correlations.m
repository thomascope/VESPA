controlfolders = {'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0072_vc1/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0093_vc2/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0096_vc3/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0114_vc4/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0320_vc5/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0140_vc6/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0434_vc7/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0218_vc9/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0234_vc10/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0242_vc11/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0253_vc12/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/'};
patientfolders = {'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0085_vp1/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0087_vp2/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0121_vp5/MEGPLANARrmtf_ceffbMdMrun1_1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0130_vp6/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0135_vp7/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0150_vp8/MEGPLANARrmtf_ceffbMdMrun1_1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0184_vp9/MEGPLANARrmtf_ceffbMdMrun1_1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0205_vp10/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0222_vp11/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/';'/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_newbaseline_fixedICA/meg14_0506_vp12/MEGPLANARrmtf_ceffbMdMrun1_raw_ssst/'};
imagename = 'average.nii';
freqwin = [18 24];
timewin = [950 1050];

controlbetas = extract_power_from_images(controlfolders,imagename,freqwin,timewin);
patientbetas = extract_power_from_images(patientfolders,imagename,freqwin,timewin);

controlpriorsd = [
    1.4079
    1.2169
    2.1994
    1.6734
    0.5518
    2.4551
    2.3795
    2.3784
    1.9396
    1.6079
    1.6246];

patientpriorsd = [    0.2085
    0.0773
    2.2592
    1.2197
    1.3367
    0.1130
    0.3311
    0.5099
    0.1870
    1.5687];

controlthreshold = [    0.1475
    0.1305
    0.2036
    0.2023
    0.1643
    0.2290
    0.1329
    0.2023
    0.2149
    0.2094
    0.1760];
    
patientthreshold = [0
         0
    0.1606
    0.1131
    0.2091
         0
         0
    0.3175
         0
    0.2481];

corr([controlbetas,patientbetas]',[controlpriorsd;patientpriorsd])
corr(patientbetas',patientpriorsd)