% List of open inputs
% Coregister: Estimate: Source Image - cfg_files
nrun = 20; % enter the number of runs here
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/batch_MRI_Coregister_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);

mrilist = {                                                
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0072_vc1/MRI/Recent_Structural/vc1_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0093_vc2/MRI/Recent_Structural/vc2_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0096_vc3/MRI/Recent_Structural/vc3_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0114_vc4/MRI/Recent_Structural/vc4_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0320_vc5/MRI/Recent_Structural/vc5_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0140_vc6/MRI/Recent_Structural/vc6_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0434_vc7/MRI/Recent_Structural/vc7_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0218_vc9/MRI/Recent_Structural/vc9_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0234_vc10/MRI/Recent_Structural/vc10_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0242_vc11/MRI/Recent_Structural/vc11_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0253_vc12/MRI/Recent_Structural/vc12_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0085_vp1/MRI/Recent_Structural/vp1_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0087_vp2/MRI/Recent_Structural/vp2_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0121_vp5/MRI/Recent_Structural/vp5_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0130_vp6/MRI/Recent_Structural/vp6_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0150_vp8/MRI/Recent_Structural/vp8_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0184_vp9/MRI/Recent_Structural/vp9_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0205_vp10/MRI/Recent_Structural/vp10_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0222_vp11/MRI/Recent_Structural/vp11_Structural.nii,1'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/meg14_0506_vp12/MRI/Recent_Structural/vp12_Structural.nii,1'};

for crun = 1:nrun
    inputs{2, crun} = cellstr(mrilist{crun}); % Head model specification: Individual structural image - cfg_files
end
                                             
jobs = repmat(jobfile, 1, 1);

parfor crun = 1:nrun
    spm('defaults', 'PET');
    spm_jobman('initcfg')
    try
        spm_jobman('run', jobs, inputs{:,crun});
        MRI_coreg_workedcorrectly(crun) = 1;
    catch
        MRI_coreg_workedcorrectly(crun) = 0;
    end
end
