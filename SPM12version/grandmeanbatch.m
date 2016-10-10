% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/grandmeanbatch_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'EEG');
spm_jobman('run', jobs, inputs{:});
