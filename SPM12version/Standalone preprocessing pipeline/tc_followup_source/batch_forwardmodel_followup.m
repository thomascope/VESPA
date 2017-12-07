% List of open inputs
% Head model specification: M/EEG datasets - cfg_files
% Head model specification: Individual structural image - cfg_files
nrun = 37; % enter the number of runs here
%jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/batch_forwardmodel_job_noheadpoints.m'};
jobfile = {'/group/language/data/thomascope/vespa/SPM12version/Standalone preprocessing pipeline/tc_source/batch_forwardmodel_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, nrun);
mrilist = {                                                
                                                 '/imaging/tc02/vespa/preprocess/meg14_0072_vc1/MRI/Recent_Structural/vc1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0093_vc2/MRI/Recent_Structural/vc2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0096_vc3/MRI/Recent_Structural/vc3_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0114_vc4/MRI/Recent_Structural/vc4_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0320_vc5/MRI/Recent_Structural/vc5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0140_vc6/MRI/Recent_Structural/vc6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0434_vc7/MRI/Recent_Structural/vc7_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0218_vc9/MRI/Recent_Structural/vc9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0234_vc10/MRI/Recent_Structural/vc10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0242_vc11/MRI/Recent_Structural/vc11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0253_vc12/MRI/Recent_Structural/vc12_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0085_vp1/MRI/Recent_Structural/vp1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0087_vp2/MRI/Recent_Structural/vp2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0121_vp5/MRI/Recent_Structural/vp5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0130_vp6/MRI/Recent_Structural/vp6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0135_vp7/MRI/template/avg152T1.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0150_vp8/MRI/Recent_Structural/vp8_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0184_vp9/MRI/Recent_Structural/vp9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0205_vp10/MRI/Recent_Structural/vp10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0222_vp11/MRI/Recent_Structural/vp11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0506_vp12/MRI/Recent_Structural/vp12_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0072_vc1/MRI/Recent_Structural/vc1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0093_vc2/MRI/Recent_Structural/vc2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0114_vc4/MRI/Recent_Structural/vc4_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0140_vc6/MRI/Recent_Structural/vc6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0434_vc7/MRI/Recent_Structural/vc7_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0218_vc9/MRI/Recent_Structural/vc9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0234_vc10/MRI/Recent_Structural/vc10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0242_vc11/MRI/Recent_Structural/vc11_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0253_vc12/MRI/Recent_Structural/vc12_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0085_vp1/MRI/Recent_Structural/vp1_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0087_vp2/MRI/Recent_Structural/vp2_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0121_vp5/MRI/Recent_Structural/vp5_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0130_vp6/MRI/Recent_Structural/vp6_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0184_vp9/MRI/Recent_Structural/vp9_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0205_vp10/MRI/Recent_Structural/vp10_Structural.nii,1'
                                                 '/imaging/tc02/vespa/preprocess/meg14_0506_vp12/MRI/Recent_Structural/vp12_Structural.nii,1'
                                                 };
meglist = {                                              
                                                '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0072_vc1/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0093_vc2/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0096_vc3/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0114_vc4/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0320_vc5/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0140_vc6/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0434_vc7/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0218_vc9/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0234_vc10/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0242_vc11/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0253_vc12/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0085_vp1/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0087_vp2/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0121_vp5/fmcfbMdeMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0130_vp6/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0135_vp7/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0150_vp8/fmcfbMdeMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0184_vp9/fmcfbMdeMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0205_vp10/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0222_vp11/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0506_vp12/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0072_vc1_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0093_vc2_fup/fmcfbMdeMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0114_vc4_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0140_vc6_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0434_vc7_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0218_vc9_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0234_vc10_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0242_vc11_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0253_vc12_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0085_vp1_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0087_vp2_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0121_vp5_fup/fmcfbMdeMrun1_1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0130_vp6_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0184_vp9_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0205_vp10_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 '/imaging/tc02/vespa_followup/preprocess/SPM12_fullpipeline/meg14_0506_vp12_fup/fmcfbMdeMrun1_raw_ssst.mat'
                                                 };


                                             
load('/imaging/tc02/vespa/preprocess/controls_mni');
load('/imaging/tc02/vespa/preprocess/patients_mni');
controlsmni{end-3}{1} = char(controlsmni{end-3}{1}); % Fix double cell on vc9
%allmni = [corrected_controlsmni, corrected_patientsmni]';
allmni = [controlsmni, patientsmni]';

follow_up_subjs = meglist(22:end);
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));

for i = 1:size(follow_up_subjs,1)
temp = strsplit(follow_up_subjs{i},'_');
logical_cells = cellfun(cellfind(char(temp(5))),allmni,'UniformOutput',0);
[row,col]=find(cell2mat(logical_cells));
allmni = [allmni; {allmni{row}}];
end

                                             
% if length(meglist)~=nrun || length(mrilist)~=nrun || length(datadir_early)~=nrun || length(datadir_late)~=nrun
%     error('The number of runs specified is not the same as the length of one of the inputs. Please double check this.')
% end
for crun = 1:nrun
    inputs{1, crun} = cellstr(meglist{crun}); % Head model specification: M/EEG datasets - cfg_files
    inputs{2, crun} = cellstr(mrilist{crun}); % Head model specification: Individual structural image - cfg_files
    inputs{3, crun} = allmni{crun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{4, crun} = allmni{crun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
    inputs{5, crun} = allmni{crun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
end

%% First make sure that misplaced channels are marked as bad (I initially thought that these were digitised to wrong location, but actually seems to be a maxfilter problem - maybe could interpolate if want to keep them?)
load('/imaging/tc02/vespa/preprocess/controls_badeegloc','controlsbadeegloc');
load('/imaging/tc02/vespa/preprocess/patients_badeegloc','patientsbadeegloc');
allbadeegloc = [controlsbadeegloc; patientsbadeegloc];

for crun = 1:size(allbadeegloc,1)
    toremove = {};
    D = spm_eeg_load(meglist{crun});
    for i = 1:length(allbadeegloc{crun})
        if allbadeegloc{crun}(i) == 0
        elseif allbadeegloc{crun}(i) <10
            toremove{i} = strcat('EEG00', num2str(allbadeegloc{crun}(i)));
        elseif allbadeegloc{crun}(i) <100
            toremove{i} = strcat('EEG0', num2str(allbadeegloc{crun}(i)));  
        elseif allbadeegloc{crun}(i) >=100
            toremove{i} = strcat('EEG', num2str(allbadeegloc{crun}(i)));   
        end
    end
    cids = D.indchannel(toremove);
    if ~isempty(cids)
        D = D.badchannels(cids,1);
        D.save;
    end
    
end

%% Now compute the forwards model
forwardmodelworkedcorrectly = zeros(1,nrun);
jobs = repmat(jobfile, 1, 1);

parfor crun = 1:nrun
    spm('defaults', 'EEG');
    spm_jobman('initcfg')
    try
        spm_jobman('run', jobs, inputs{:,crun});
        forwardmodelworkedcorrectly(crun) = 1;
    catch
        forwardmodelworkedcorrectly(crun) = 0;
    end
end



% >> Old code
% for crun = nrun+1:2*nrun
%     inputs{1, crun} = cellstr(meglist{crun-nrun}); % Head model specification: M/EEG datasets - cfg_files
%     inputs{2, crun} = cellstr(mrilist{crun-nrun}); % Head model specification: Individual structural image - cfg_files
%     inputs{3, crun} = allmni{crun-nrun}{2}(1,:); % Head model specification: Type MRI coordinates - cfg_entry
%     inputs{4, crun} = allmni{crun-nrun}{2}(2,:); % Head model specification: Type MRI coordinates - cfg_entry
%     inputs{5, crun} = allmni{crun-nrun}{2}(3,:); % Head model specification: Type MRI coordinates - cfg_entry
% end
% spm('defaults', 'EEG');
% spm_jobman('run', jobs, inputs{:});
% beamformingworkedcorrectly = zeros(1,2*nrun);
% jobs = repmat(jobfile, 1, 1);
% parfor crun = 1:2*nrun
%     addpath('/imaging/local/software/spm_cbu_svn/releases/spm12_latest/toolbox/DAiSS')
%     spm('defaults', 'EEG');
%     spm_jobman('initcfg')
%     try
%         spm_jobman('run', jobs, inputs{:,crun});
%         beamformingworkedcorrectly(crun) = 1;
%     catch
%         beamformingworkedcorrectly(crun) = 0;
%     end
% end


% datadir_early = {                                              
%                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0072_vc1/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0093_vc2/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0096_vc3/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0114_vc4/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0320_vc5/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0140_vc6/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0434_vc7/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0218_vc9/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0234_vc10/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0242_vc11/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0253_vc12/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0085_vp1/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0087_vp2/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0121_vp5/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0130_vp6/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0135_vp7/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0150_vp8/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0184_vp9/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0205_vp10/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0222_vp11/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/early/meg14_0506_vp12/'};
% datadir_late = {                                              
%                                                 '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0072_vc1/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0093_vc2/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0096_vc3/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0114_vc4/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0320_vc5/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0140_vc6/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0434_vc7/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0218_vc9/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0234_vc10/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0242_vc11/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0253_vc12/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0085_vp1/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0087_vp2/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0121_vp5/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0130_vp6/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0135_vp7/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0150_vp8/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0184_vp9/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0205_vp10/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0222_vp11/'
%                                                  '/imaging/tc02/vespa/preprocess/SPM12_fullpipeline/testbeamforming/eLORETA_restricted_planaronly/late/meg14_0506_vp12/'};
