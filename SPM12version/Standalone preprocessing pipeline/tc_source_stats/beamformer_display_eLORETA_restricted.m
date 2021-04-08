%%
cfg.plots = [1 2];
cfg.symmetricity = 'symmetrical';
cfg.normalise = 1;
cfg.threshold = [3.09 9];

addpath([pwd '/ojwoodford-export_fig-216b30e'])

%Render Patients>Controls
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/spmT_0001.nii','jet',cfg)
export_fig thresholded_draft_beamformer_eLORETA_restricted_1.png -transparent
jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/spmT_0001.nii','jet',cfg)
export_fig thresholded_draft_beamformer_eLORETA_restricted_2.png -transparent

% %Render Controls>Patients
% jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/spmT_0002.nii','jet',cfg)
% export_fig thresholded_draft_beamformer_eLORETA_restricted_1.png -transparent
% jp_spm8_surfacerender2_version_tc('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/spmT_0002.nii','jet',cfg)
% export_fig thresholded_draft_beamformer_eLORETA_restricted_2.png -transparent

%export_fig thresholded_draft_reconstructions_msp.png -transparent

%%

figure
image_to_add = imread('thresholded_draft_beamformer_eLORETA_restricted_1.png');
%Assume that all images are the same size
imagearray = uint8(zeros(size(image_to_add,1)*2, size(image_to_add,2), 3));
imagearray = imagearray+204;
imagearray(1:size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;

for imagenumber = 2
image_to_add = imread(['thresholded_draft_beamformer_eLORETA_restricted_2.png']);
%Assume that all images are the same size
imagearray(size(image_to_add,1)+1:2*size(image_to_add,1),1:size(image_to_add,2),:) = image_to_add;
end
imshow(imagearray)

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

export_fig thresholded_draft_beamformer_eLORETA_restricted_0.001_total.png -transparent
