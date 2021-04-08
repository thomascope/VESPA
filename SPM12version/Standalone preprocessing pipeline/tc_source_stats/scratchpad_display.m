%%
cfg.plots = [1];
cfg.symmetricity = 'symmetrical';
cfg.normalise = 1;
cfg.threshold = [5 40];
cfg.inflate = 10;

addpath([pwd '/ojwoodford-export_fig-216b30e'])

%Render effect of prime congruency
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_5.png -transparent

%Render effect of sensory detail
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_6.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_7.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_8.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_9.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_10.png -transparent

%Render effect of prime congruency
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_1_t90_130_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MSP_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_1_t180_240_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MSP_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_1_t270_420_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MSP_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_1_t450_700_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MSP_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNI_source/fmcfbMdeMrun1_raw_ssst_1_t750_900_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig MSP_MNI_thresholded_draft_reconstructions_5.png -transparent

%Plot TF source reconstruction beta band
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t90_130_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t180_240_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t270_420_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t450_700_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t750_900_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency _ 'corrected' fiducials
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig corrected_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig corrected_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig corrected_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig corrected_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig corrected_MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency _ 'corrected' fiducials
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t90_130_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_corrected_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t180_240_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_corrected_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t270_420_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_corrected_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t450_700_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_corrected_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t750_900_f16_31*/GA_Match-MisMatch.nii','jet',cfg)
export_fig Beta_corrected_MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency _ 'corrected' fiducials
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t90_130_f16_31*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t180_240_f16_31*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t270_420_f16_31*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t450_700_f16_31*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t750_900_f16_31*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency _ 'corrected' fiducials
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t90_130_f16_31*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t180_240_f16_31*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t270_420_f16_31*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t450_700_f16_31*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_inducedbeta_MNI_source/cfbMdeMrun1_raw_ssst_5_t750_900_f16_31*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_thresholded_draft_reconstructions_5.png -transparent
%export_fig thresholded_draft_reconstructions.png -transparent

%Render effect of prime congruency _ 'corrected' fiducials
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Controls_corrected_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Controls_corrected_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Controls_corrected_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Controls_corrected_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/Controls_Match-MisMatch.nii','jet',cfg)
export_fig Controls_corrected_MNI_thresholded_draft_reconstructions_5.png -transparent

%Render effect of prime congruency _ 'corrected' fiducials
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t90_130_f1_40*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Patients_corrected_MNI_thresholded_draft_reconstructions_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t180_240_f1_40*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Patients_corrected_MNI_thresholded_draft_reconstructions_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t270_420_f1_40*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Patients_corrected_MNI_thresholded_draft_reconstructions_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t450_700_f1_40*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Patients_corrected_MNI_thresholded_draft_reconstructions_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_fixedloadproblem_MNIcorrected_source/fmcfbMdeMrun1_raw_ssst_5_t750_900_f1_40*/Patients_Match-MisMatch.nii','jet',cfg)
export_fig Patients_corrected_MNI_thresholded_draft_reconstructions_5.png -transparent

%Render SPMs for prime congruency _ 'corrected' fiducials
cfg.normalise = 0;
cfg.threshold = [1.65 5]; %p=0.05
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/90_130/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/180_240/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/270_420/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/450_700/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/750_900/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_5.png -transparent

jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/90_130/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/180_240/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/270_420/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/450_700/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/750_900/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_5.png -transparent

%Render SPMs for prime congruency _ 'corrected' fiducials
cfg.normalise = 0;
cfg.threshold = [2.58 5]; %p=0.005
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/90_130/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/180_240/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/270_420/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/450_700/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/750_900/spmT_0003.nii','jet',cfg)
export_fig Controls_corrected_MNI_SPM_5.png -transparent

jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/90_130/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/180_240/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/270_420/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/450_700/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_2_withMNI/reconstruction_5/stats_testttest/750_900/spmT_0004.nii','jet',cfg)
export_fig Patients_corrected_MNI_SPM_5.png -transparent

%Render Beta SPMs for prime congruency _ 'corrected' fiducials
cfg.normalise = 0;
cfg.threshold = [1.65 5]; %p=0.005
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/350_500/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/520_670/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/750_900/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_3.png -transparent

jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/350_500/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/520_670/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/750_900/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_3.png -transparent

%Render Beta SPMs for prime congruency _ 'corrected' fiducials
cfg.normalise = 0;
cfg.threshold = [2.58 5]; %p=0.005
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/90_130/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/180_240/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/270_420/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/450_700/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/750_900/spmT_0003.nii','jet',cfg)
export_fig Beta_Controls_corrected_MNI_SPM_5.png -transparent

jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/90_130/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/180_240/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/270_420/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/450_700/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/tc_source_tf_restricted_withcorrectedMNI/reconstruction_5/stats/750_900/spmT_0004.nii','jet',cfg)
export_fig Beta_Patients_corrected_MNI_SPM_5.png -transparent

%%

figure
image_to_add = imread('Controls_corrected_MNI_thresholded_draft_reconstructions_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, size(image_to_add,2)*5, 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2:5
image_to_add = imread(['Controls_corrected_MNI_thresholded_draft_reconstructions_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
end
for imagenumber = 6:10
image_to_add = imread(['Patients_corrected_MNI_thresholded_draft_reconstructions_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
end
imshow(imagearray)
export_fig thresholded_draft_reconstructions_total.png -transparent


figure
image_to_add = imread('Controls_corrected_MNI_SPM_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, size(image_to_add,2)*5, 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2:5
image_to_add = imread(['Controls_corrected_MNI_SPM_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
end
for imagenumber = 6:10
image_to_add = imread(['Patients_corrected_MNI_SPM_' num2str(imagenumber-5) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
end

black = all(imagearray==0,3);
imagearray_2 = imagearray;
for i = 1:size(black,1)
    for j = 1:size(black,2)
        if black(i,j) == 1
            imagearray_2(i,j,:)=355;
        end
    end
end

imshow(imagearray_2)
export_fig spm_reconstructions_total.png -transparent

