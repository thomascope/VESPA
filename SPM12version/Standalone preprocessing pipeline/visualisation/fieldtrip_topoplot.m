% Plots the topoplot of the planar gradiometer grandmeans specified in a given timewindow for
% a given contrastnumber. In this example Match-Mismatch is contrastnumber2

function fieldtrip_topoplot(timewindow,contrastnumber)

data{1} = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/meg14_0072_vc1/controls_weighted_grandmean.mat');
data{2} = spm_eeg_load('/imaging/mlr/users/tc02/vespa/preprocess/SPM12_fullpipeline_fixedICA/meg14_0085_vp1/patients_weighted_grandmean.mat');

addpath /imaging/local/software/fieldtrip/fieldtrip-current
rmpath('/imaging/local/software/spm_cbu_svn/releases/spm12_latest/external/fieldtrip/')
ft_defaults
for dataset = 1:2
    cfg = [];
    planardata = data{dataset}.fttimelock(data{dataset}.selectchannels('MEGPLANAR'),:,contrastnumber);
    cfg.layout = 'neuromag306planar.lay';
    layout = ft_prepare_layout(cfg,planardata);
    cfg.layout = layout;
    cfg.xlim = timewindow;
    cfg.gridscale = 300; %Can increase to 600 for better quality, but takes 30seconds per image.
    cfg.style = 'straight';
    cfg.colorbar = 'yes';
    timelock = ft_timelockanalysis(cfg, planardata);
    figure
    ft_topoplotER(cfg,timelock);
    colorbar
    if dataset == 1
        title(['Controls topoplot for planar gradiometers at time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2))])
    else
        title(['Patients topoplot for planar gradiometers at time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2))])
    end
end
for dataset = 1:2
    cfg = [];
    planardata = data{dataset}.fttimelock(data{dataset}.selectchannels('MEG'),:,contrastnumber);
    cfg.layout = 'neuromag306mag.lay';
    layout = ft_prepare_layout(cfg,planardata);
    cfg.layout = layout;
    cfg.xlim = timewindow;
    cfg.gridscale = 300;
    cfg.style = 'straight';
    cfg.colorbar = 'yes';
    timelock = ft_timelockanalysis(cfg, planardata);
    figure
    ft_topoplotER(cfg,timelock);
    colorbar
    if dataset == 1
        title(['Controls topoplot for magnetometers at time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2))])
    else
        title(['Patients topoplot for magnetometers at time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2))])
    end
end
for dataset = 1:2
    cfg = [];
    planardata = data{dataset}.fttimelock(data{dataset}.selectchannels('EEG'),:,contrastnumber);
    cfg.layout = 'neuromag306eeg1005_natmeg.lay';
    layout = ft_prepare_layout(cfg,planardata);
    cfg.layout = layout;
    cfg.xlim = timewindow;
    cfg.gridscale = 300;
    cfg.style = 'straight';
    cfg.colorbar = 'yes';
    timelock = ft_timelockanalysis(cfg, planardata);
    figure
    ft_topoplotER(cfg,timelock);
    colorbar
    if dataset == 1
        title(['Controls topoplot for EEG at time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2))])
    else
        title(['Patients topoplot for EEG at time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2))])
    end
end

