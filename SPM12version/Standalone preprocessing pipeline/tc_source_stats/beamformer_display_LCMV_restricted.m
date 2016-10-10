%%
cfg.plots = [1 2];
cfg.symmetricity = 'symmetrical';
cfg.normalise = 1;
cfg.threshold = [3.09 9];

addpath([pwd '/ojwoodford-export_fig-216b30e'])

%Render Patients>Controls
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/LCMV_restricted_planaronly/early/spmT_0001.nii','jet',cfg)
export_fig thresholded_draft_beamformer_LCMV_restricted_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/LCMV_restricted_planaronly/late/spmT_0001.nii','jet',cfg)
export_fig thresholded_draft_beamformer_LCMV_restricted_2.png -transparent

%Render Controls>Patients
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/LCMV_restricted_planaronly/early/spmT_0002.nii','jet',cfg)
export_fig thresholded_draft_beamformer_LCMV_restricted_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/LCMV_restricted_planaronly/late/spmT_0002.nii','jet',cfg)
export_fig thresholded_draft_beamformer_LCMV_restricted_2.png -transparent

%export_fig thresholded_draft_reconstructions_msp.png -transparent

%%

figure
image_to_add = imread('thresholded_draft_beamformer_LCMV_restricted_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, size(image_to_add,2), 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2
image_to_add = imread(['thresholded_draft_beamformer_LCMV_restricted_2.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
end
imshow(imagearray)
export_fig thresholded_draft_beamformer_LCMV_restricted_0.05_total.png -transparent
