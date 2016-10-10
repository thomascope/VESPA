%%
cfg.plots = [1];
cfg.symmetricity = 'symmetrical';
cfg.normalise = 1;
cfg.threshold = [5 40];

addpath([pwd '/ojwoodford-export_fig-216b30e'])

%Render effect of prime congruency
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t90_130_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t180_240_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_2.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t270_420_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_3.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t450_700_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_4.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t750_900_f1_40*/GA_Match-MisMatch.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_5.png -transparent

%Render effect of sensory detail
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t90_130_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_6.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t180_240_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_7.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t270_420_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_8.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t450_700_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_9.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/es_source/fmcfbMdeMrun1_raw_ssst_2_t750_900_f1_40*/GA_Clear minus Unclear.nii','jet',cfg)
export_fig thresholded_draft_reconstructions_msp_10.png -transparent

%export_fig thresholded_draft_reconstructions_msp.png -transparent

%%

figure
image_to_add = imread('thresholded_draft_reconstructions_msp_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, size(image_to_add,2)*5, 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2:5
image_to_add = imread(['thresholded_draft_reconstructions_msp_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(1:size(image_to_add,1),1+(imagenumber-1)*size(image_to_add,2):imagenumber*size(image_to_add,2),:) = image_to_add;
end
for imagenumber = 6:10
image_to_add = imread(['thresholded_draft_reconstructions_msp_' num2str(imagenumber) '.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1+(imagenumber-6)*size(image_to_add,2):(imagenumber-5)*size(image_to_add,2),:) = image_to_add;
end
imshow(imagearray)
export_fig thresholded_draft_reconstructions_msp_total.png -transparent
