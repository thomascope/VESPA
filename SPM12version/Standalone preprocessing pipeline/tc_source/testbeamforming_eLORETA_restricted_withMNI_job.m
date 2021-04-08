%-----------------------------------------------------------------------
% Job saved on 10-Dec-2014 15:50:53 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.source.headmodel.D = '<UNDEFINED>';
%matlabbatch{1}.spm.meeg.source.headmodel.D = {'/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_tf/meg14_0072_vc1/ceffbMdMrun1_raw_ssst.mat'};
matlabbatch{1}.spm.meeg.source.headmodel.val = 1;
matlabbatch{1}.spm.meeg.source.headmodel.comment = '';
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.mri = '<UNDEFINED>';
%matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshes.mri = {'/imaging/mlr/users/tc02/vespa/preprocess/meg14_0072_vc1/MRI/Recent_Structural/vc1_Structural.nii,1'};
matlabbatch{1}.spm.meeg.source.headmodel.meshing.meshres = 2;
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).fidname = 'Nasion';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(1).specification.type = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).fidname = 'LPA';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(2).specification.type = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).fidname = 'RPA';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.fiducial(3).specification.type = '<UNDEFINED>';
matlabbatch{1}.spm.meeg.source.headmodel.coregistration.coregspecify.useheadshape = 1;
matlabbatch{1}.spm.meeg.source.headmodel.forward.eeg = 'EEG BEM';
matlabbatch{1}.spm.meeg.source.headmodel.forward.meg = 'Single Shell';
matlabbatch{2}.spm.tools.beamforming.data.dir = '<UNDEFINED>'; 
%matlabbatch{2}.spm.tools.beamforming.data.dir = {'/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming'};
matlabbatch{2}.spm.tools.beamforming.data.D(1) = cfg_dep('Head model specification: M/EEG dataset(s) with a forward model', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','D'));
matlabbatch{2}.spm.tools.beamforming.data.val = 1;
matlabbatch{2}.spm.tools.beamforming.data.gradsource = 'inv';
matlabbatch{2}.spm.tools.beamforming.data.space = 'MNI-aligned';
matlabbatch{2}.spm.tools.beamforming.data.overwrite = 1;
matlabbatch{3}.spm.tools.beamforming.sources.BF(1) = cfg_dep('Prepare data: BF.mat file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{3}.spm.tools.beamforming.sources.reduce_rank = [2 3];
matlabbatch{3}.spm.tools.beamforming.sources.keep3d = 1;
matlabbatch{3}.spm.tools.beamforming.sources.plugin.grid.resolution = 10;
matlabbatch{3}.spm.tools.beamforming.sources.plugin.grid.space = 'MNI-aligned';
matlabbatch{3}.spm.tools.beamforming.sources.visualise = 1;
matlabbatch{4}.spm.tools.beamforming.features.BF(1) = cfg_dep('Define sources: BF.mat file', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{4}.spm.tools.beamforming.features.whatconditions.all = 1;
matlabbatch{4}.spm.tools.beamforming.features.woi = [300 950];
matlabbatch{4}.spm.tools.beamforming.features.modality = {
                                                          'MEGPLANAR'
                                                          }';
matlabbatch{4}.spm.tools.beamforming.features.fuse = 'all';
matlabbatch{4}.spm.tools.beamforming.features.plugin.csd.foi = [12 24];
matlabbatch{4}.spm.tools.beamforming.features.plugin.csd.taper = 'hanning';
matlabbatch{4}.spm.tools.beamforming.features.plugin.csd.keepreal = 1;
matlabbatch{4}.spm.tools.beamforming.features.plugin.csd.hanning = 1;
matlabbatch{4}.spm.tools.beamforming.features.regularisation.mantrunc.pcadim = 50; %THIS IS ABSOLUTELY NECESSARY FOR ELEKTA DATA!!!
matlabbatch{4}.spm.tools.beamforming.features.bootstrap = false;
matlabbatch{5}.spm.tools.beamforming.inverse.BF(1) = cfg_dep('Covariance features: BF.mat file', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{5}.spm.tools.beamforming.inverse.plugin.eloreta.regularisation = 0.05;
matlabbatch{6}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.whatconditions.all = 1;
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.sametrials = true;
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.woi = '<UNDEFINED>';
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.foi = [12 24];
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.result = 'bycondition';
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
matlabbatch{6}.spm.tools.beamforming.output.plugin.image_power.modality = 'MEGPLANAR';
matlabbatch{7}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{7}.spm.tools.beamforming.write.plugin.nifti.normalise = 'no';
matlabbatch{7}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
matlabbatch{8}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.whatconditions.all = 1;
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.sametrials = true;
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.woi = '<UNDEFINED>';
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.foi = [12 24];
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.result = 'singleimage';
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
matlabbatch{8}.spm.tools.beamforming.output.plugin.image_power.modality = 'MEGPLANAR';
matlabbatch{9}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
matlabbatch{9}.spm.tools.beamforming.write.plugin.nifti.normalise = 'no';
matlabbatch{9}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
% matlabbatch{10}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.whatconditions.all = 1;
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.sametrials = false;
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.woi = '<UNDEFINED>';
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.foi = [10 45];
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.result = 'bycondition';
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
% matlabbatch{10}.spm.tools.beamforming.output.plugin.image_power.modality = 'MEG';
% matlabbatch{11}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
% matlabbatch{11}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
% matlabbatch{11}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';
% matlabbatch{12}.spm.tools.beamforming.output.BF(1) = cfg_dep('Inverse solution: BF.mat file', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.whatconditions.all = 1;
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.sametrials = false;
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.woi = '<UNDEFINED>';
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.foi = [10 45];
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.contrast = 1;
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.result = 'singleimage';
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.scale = 1;
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.powermethod = 'trace';
% matlabbatch{12}.spm.tools.beamforming.output.plugin.image_power.modality = 'MEG';
% matlabbatch{13}.spm.tools.beamforming.write.BF(1) = cfg_dep('Output: BF.mat file', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','BF'));
% matlabbatch{13}.spm.tools.beamforming.write.plugin.nifti.normalise = 'separate';
% matlabbatch{13}.spm.tools.beamforming.write.plugin.nifti.space = 'mni';