% This file removes ICA artefacts from data, then moves MMN+Rest files to a
% different folder to allow further pre-processing of VESPA data
% TEC March 2014

addpath('/imaging/local/eeglab/');
%addpath(genpath('/imaging/local/software/fieldtrip/fieldtrip-current'))
eeglab;
spm eeg
PCA_dim = 60;      % Number of PCs for ICA
CorPval = .05/PCA_dim;  % Kind of 2-tailed Bonferonni?
CorThr  = 100*(1-CorPval);
VarThr = 100/PCA_dim;
Nperm = round((4*sqrt(CorPval)/CorPval)^2);
ICAFiltPars = [40] %if try to bandpass, often fails even with dimension reduction

% [�load up your SPM continuous file, eg D = spm_eeg_load(�filename.mat�)�]

%test single rest file
modalities = {'MEGMAG' 'MEGPLANAR' 'EEG'};
D = spm_eeg_load('/imaging/tc02/vespa/preprocess/no_name/spm8_rest_raw_ssst.mat');
ref_chans = {'EOG061','EOG062','ECG063'} %,'MISC001','MISC002','MISC003'};
refs = []; % Reference signal for correlating with ICs
for a = 1:length(ref_chans)
    refs(a,:) = D(find(strcmp(D.chanlabels,ref_chans{a})),:);
end
% figure,plot(refs')

chans = {}; ica_remove = {}; weights = {}; datacor = {}; TraMat = {};

for m = 1:length(modalities)
    
    chans{m} = find(strcmp(D.chantype,modalities{m}));
    d  = D(chans{m},:);
    
    FiltPars = [ICAFiltPars D.fsample];
    
    [ica_remove{m},weights{m},TraMat{m},ICs,datacor{m},varexpl] = remove_ICA_artefacts(d,refs,PCA_dim,Nperm,CorThr,VarThr,FiltPars);
    
    % figure,hist(datacor{m}')
    % figure,plot(ICs(:,ica_remove{m}))
end

% [�then at some point later when you want to remove artifacts from data�]

S = []; S.D = D;
achans = cat(2,chans{:});
for c = 1:length(achans)
    S.montage.labelorg{c} = D.chanlabels{achans(c)};
end
S.montage.labelnew = S.montage.labelorg;
S.montage.tra      = blkdiag(TraMat{:});
S.keepothers       = 1;
D = spm_eeg_montage(S);
D.save;