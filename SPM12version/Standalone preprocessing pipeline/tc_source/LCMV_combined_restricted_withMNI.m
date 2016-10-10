% List of open inputs
% Head model specification: M/EEG datasets - cfg_files
% Head model specification: Individual structural image - cfg_files
% Head model specification: Type MRI coordinates - cfg_entry
% Head model specification: Type MRI coordinates - cfg_entry
% Head model specification: Type MRI coordinates - cfg_entry
% Prepare data: Directory - cfg_files
% Output: Time windows of interest - cfg_entry
% Output: Time windows of interest - cfg_entry
nrun = X; % enter the number of runs here
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/LCMV_combined_restricted_withMNI_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(8, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % Head model specification: Type MRI coordinates - cfg_entry
    inputs{6, crun} = MATLAB_CODE_TO_FILL_INPUT; % Prepare data: Directory - cfg_files
    inputs{7, crun} = MATLAB_CODE_TO_FILL_INPUT; % Output: Time windows of interest - cfg_entry
    inputs{8, crun} = MATLAB_CODE_TO_FILL_INPUT; % Output: Time windows of interest - cfg_entry
end
spm('defaults', 'EEG');
spm_jobman('run', jobs, inputs{:});
