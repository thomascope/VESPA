% List of open inputs
% Output: BF.mat file - cfg_files
nrun = 21; % enter the number of runs here
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/LCMV_second_source_extraction_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);
datadir_early = {                                              
                                                '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0072_vc1/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0093_vc2/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0096_vc3/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0114_vc4/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0320_vc5/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0140_vc6/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0434_vc7/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0218_vc9/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0234_vc10/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0242_vc11/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0253_vc12/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0085_vp1/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0087_vp2/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0121_vp5/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0130_vp6/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0135_vp7/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0150_vp8/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0184_vp9/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0205_vp10/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0222_vp11/'
                                                 '/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/final_LCMV_trunkated_restricted/early/meg14_0506_vp12/'};


for crun = 1:nrun
    inputs{1, crun} = cellstr([datadir_early{crun} 'BF.mat']); % Output: BF.mat file - cfg_files    
end

sourceextractworkedcorrectly = zeros(1,nrun);
jobs = repmat(jobfile, 1, 1);

parfor crun = 1:nrun
    addpath('/imaging/local/software/spm_cbu_svn/releases/spm12_latest/toolbox/DAiSS')
    spm('defaults', 'EEG');
    spm_jobman('initcfg')
    try
        spm_jobman('run', jobs, inputs{:,crun});
        sourceextractworkedcorrectly(crun) = 1;
    catch
        sourceextractworkedcorrectly(crun) = 0;
    end
end
