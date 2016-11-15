% Plots the topoplot of the planar gradiometer grandmeans specified in a given timewindow for
% a given contrastnumber. In this example Match-Mismatch is contrastnumber2

function fieldtrip_topoplot_highlight_tf(timewindow,contrastnumber,frequency,modality)

timewindow = timewindow/1000; %time window input in ms, but fieldtrip needs it in seconds

data{1} = spm_eeg_load('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0072_vc1/controls_weighted_grandmean.mat');
data{2} = spm_eeg_load('/imaging/tc02/vespa/preprocess/SPM12_fullpipeline_tf_fixedICA/meg14_0085_vp1/patients_weighted_grandmean.mat');

addpath /imaging/local/software/fieldtrip/fieldtrip-current
rmpath('/imaging/local/software/spm_cbu_svn/releases/spm12_latest/external/fieldtrip/')
ft_defaults

controlfig = figure;
patientfig = figure;
if strcmp(modality,'MEGPLANAR') || strcmp(modality,'MEGCOMB')
    figHandles = findobj('Type','axes');
    scales = zeros(2,2);
    for dataset = 1:2
        cfg = [];
        planardata = data{dataset}.fttimelock(data{dataset}.selectchannels('MEGPLANAR'),:,contrastnumber);
        cfg.layout = 'neuromag306planar.lay';
        %cfg.zlim = [0 10];
        layout = ft_prepare_layout(cfg,planardata);
        cfg.layout = layout;
        cfg.xlim = timewindow;
        cfg.ylim = frequency;
        cfg.gridscale = 300; %Can increase to 600 for better quality, but takes 30seconds per image.
        cfg.style = 'straight';
        cfg.colorbar = 'yes';
        cfg.marker = 'off';
        
        if dataset == 1
            figure(controlfig)
            title_text = ['Controls topoplot for planar gradiometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz'];
        else
            figure(patientfig)
            title_text = ['Patients topoplot for planar gradiometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz'];
        end
        
        
        ft_topoplotER(cfg,planardata);
        colorbar
        title(title_text)
        
        scales(:,dataset) = caxis;
        %         hold on
        %         h = plot(loctohighlight(1),loctohighlight(2),'wo','MarkerSize',12);
        %         set(h,'MarkerFaceColor','w')
    end
    figHandles2 = findobj('Type','axes');
    newfigHandles = setdiff(figHandles2,figHandles);
    for i = 1:length(newfigHandles)
        caxis(newfigHandles(i),[min(min(scales)) max(max(scales))])
    end
    
    figure(controlfig)
    save_string = ['./Significant_peaks/Controls topoplot for planar gradiometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz.pdf'];
    eval(['export_fig ''' save_string ''' -transparent'])
    close(controlfig)
    figure(patientfig)
    save_string = ['./Significant_peaks/Patients topoplot for planar gradiometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz.pdf'];
    eval(['export_fig ''' save_string ''' -transparent'])
    close(patientfig)
    
elseif strcmp(modality,'MEGMAG') || strcmp(modality,'MEG')
    figHandles = findobj('Type','axes');
    scales = zeros(2,2);
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
        cfg.marker = 'off';
        
        if dataset == 1
            figure(controlfig)
            title_text = ['Controls topoplot for magnetometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz'];
        else
            figure(patientfig)
            title_text = ['Patients topoplot for magnetometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz'];
        end
        
        
        ft_topoplotER(cfg,planardata);
        colorbar
        title(title_text)
        
        scales(:,dataset) = caxis;
        %         hold on
        %         h = plot(loctohighlight(1),loctohighlight(2),'wo','MarkerSize',12);
        %         set(h,'MarkerFaceColor','w')
    end
    figHandles2 = findobj('Type','axes');
    newfigHandles = setdiff(figHandles2,figHandles);
    for i = 1:length(newfigHandles)
        caxis(newfigHandles(i),[min(min(scales)) max(max(scales))])
    end
    
    figure(controlfig)
    save_string = ['./Significant_peaks/Controls topoplot for magnetometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz.pdf'];
    eval(['export_fig ''' save_string ''' -transparent'])
    close(controlfig)
    figure(patientfig)
    save_string = ['./Significant_peaks/Patients topoplot for magnetometers, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz.pdf'];
    eval(['export_fig ''' save_string ''' -transparent'])
    close(patientfig)
    
elseif strcmp(modality,'EEG')
    figHandles = findobj('Type','axes');
    scales = zeros(2,2);
    for dataset = 1:2
        cfg = [];
        planardata = data{dataset}.fttimelock(data{dataset}.selectchannels('EEG'),:,contrastnumber);
        cfg.layout = 'neuromag306eeg1005_natmeg.lay';
        layout = ft_prepare_layout(cfg,planardata);
        cfg.layout = layout;
        cfg.xlim = timewindow;
        cfg.ylim = frequency;
        cfg.gridscale = 300;
        cfg.style = 'straight';
        cfg.colorbar = 'yes';
        cfg.marker = 'off';
        
        if dataset == 1
            figure(controlfig)
            title_text = ['Controls topoplot for EEG, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz'];
        else
            figure(patientfig)
            title_text = ['Patients topoplot for EEG, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz'];
        end
                
        ft_topoplotER(cfg,planardata);
        colorbar
        title(title_text)
        
        scales(:,dataset) = caxis;
        %         hold on
        %         h = plot(loctohighlight(1),loctohighlight(2),'wo','MarkerSize',12);
        %         set(h,'MarkerFaceColor','w')
    end
    figHandles2 = findobj('Type','axes');
    newfigHandles = setdiff(figHandles2,figHandles);
    for i = 1:length(newfigHandles)
        caxis(newfigHandles(i),[min(min(scales)) max(max(scales))])
    end
    
    
    figure(controlfig)
    save_string = ['./Significant_peaks/Controls topoplot for EEG, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz.pdf'];
    eval(['export_fig ''' save_string ''' -transparent'])
    close(controlfig)
    figure(patientfig)
    save_string = ['./Significant_peaks/Patients topoplot for EEG, contrast ' num2str(contrastnumber) ' time window ' num2str(timewindow(1)) ' to ' num2str(timewindow(2)) ' at ' num2str(frequency) ' Hz.pdf'];
    eval(['export_fig ''' save_string ''' -transparent'])
    close(patientfig)
end
