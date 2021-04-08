function [x_loc, y_loc, z_loc] = get_3d_location(location)

Y1_data = spm_vol(spm_vol(['/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/batch_source_4/reconstruction_5/meg14_0072_vc1/Mismatch_4.nii']));
%
x_loc = round((location(1)-Y1_data.mat(1,4))/Y1_data.mat(1,1));
y_loc = round((location(2)-Y1_data.mat(2,4))/Y1_data.mat(2,2));
z_loc = round((location(3)-Y1_data.mat(3,4))/Y1_data.mat(3,3));